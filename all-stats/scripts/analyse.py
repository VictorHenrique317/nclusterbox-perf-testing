import numpy as np
from scipy import stats
import os
import sys
import matplotlib.pyplot as plt

def take_averages(datasets, nb_iterations):
    base_folder = f'formated-perf-results'
    
    for dataset in datasets:
        for j in [1,2,3,4]:
            features_values_sum = dict()

            for iteration in range(1, nb_iterations + 1):
                file_name = f"{base_folder}/{dataset}/j{j}/{iteration}.txt"
                lines = [line.decode("utf-8") for line in open(file_name, 'rb')]
                for line in lines:
                    if line.strip() == '':
                        continue
                    
                    value, parameter = line.split(" ")
                    parameter = parameter.strip()
                    value = value.strip()

                    if parameter != "explanatory-power-maximization-time":
                        value = value.replace('.', '')

                    value = float(value)

                    if value == 0.0:
                        continue

                    features_values_sum[j] = features_values_sum.get(j, {})
                    features_values_sum[j][parameter] = features_values_sum[j].get(parameter, 0) + value

            
            with open(f"{base_folder}/{dataset}/j{j}/averages.txt", "w") as f:
                for j, parameters_sums in features_values_sum.items():
                    for parameter, value_sum in parameters_sums.items():
                        average = round(value_sum / nb_iterations, 4)
                        f.write(f"{average} {parameter}\n")
                        

def load_data(base_folder):
    parameter_values = {}

    for j in range(1,5):
        filename = f"{base_folder}/j{j}/averages.txt"
        lines = [line.decode("utf-8") for line in open(filename, 'rb')]
        

        for line in lines:
            if line.strip() == '':
                continue

            value, parameter = line.split()      
            value = float(value)

            if value == 0.0:
                continue
            
            if parameter == 'explanatory-power-maximization-time':
                value *= j
            
            parameter_values[parameter] = parameter_values.get(parameter, [])
            parameter_values[parameter].append(value)

    return parameter_values

def plot_speedup(dataset):
    base_folder = f'formated-perf-results/{dataset}'
    
    timej_values = {}

    for j in range(1,5):
        filename = f"{base_folder}/j{j}/averages.txt"
        lines = [line.decode("utf-8") for line in open(filename, 'rb')]

        for line in lines:
            value, parameter = line.split()      

            if parameter == 'explanatory-power-maximization-time':
                value = float(value)
                timej_values[j] = value

    speedup_values = {}
    for j in range(1,5):
        speedup_values[j] = timej_values[1] / timej_values[j]

    plt.plot([1,2,3,4], [1,2,3,4], 'o-', label="Speedup ideal")
    plt.plot(speedup_values.keys(), speedup_values.values(), 'o-', label="Speedup real")
    
    plt.xlabel("Número de threads")
    plt.ylabel("Speedup")
    plt.title(f"Speedup para o dataset {dataset}")
    plt.legend()
    plt.grid()
    plt.xticks([1,2,3,4])
    plt.savefig(f"plots/speedup-{dataset}.png")
    plt.clf()

    print("Speedup para cada número de threads:")
    for j, speedup in speedup_values.items():
        print(f"    {int(j)} threads: {speedup}")


def calculate_pearson(dataset):
    base_folder = f'formated-perf-results/{dataset}'
    parameters_values = load_data(base_folder)
        
    parameters_correlations = {}
    for parameter, values in parameters_values.items():
        if parameter == "explanatory-power-maximization-time":
            continue

        x = values
        y = parameters_values["explanatory-power-maximization-time"]
        r, p = stats.pearsonr(x, y)
        parameters_correlations[parameter] = (round(r, 4), round(p, 4))

    max_len = max(len(parameter) for parameter in parameters_correlations.keys())
    print("R de Pearson e p-valor para cada parâmetro (BRUTO):")
    for parameter, (r, p) in sorted(parameters_correlations.items(), key=lambda x: x[1][0], reverse=True):
        print(f"    {parameter:<{max_len + 4}} r: {r:<10} p: {p:<10}")

    print()
    print("R de Pearson e p-valor para cada parâmetro com RELEVANCIA ESTATISTICA (p < 0.05):")
    for parameter, (r, p) in sorted(parameters_correlations.items(), key=lambda x: x[1][0], reverse=True):
        if p < 0.05:
            print(f"    {parameter:<{max_len + 4}} r: {r:<10} p: {p:<10}")

    print()

datasets = sys.argv[1].split(" ")
nb_iterations = int(sys.argv[2])

take_averages(datasets, nb_iterations)
for dataset in datasets:
    print(f"=============================== DATASET: {dataset} ================================")
    plot_speedup(dataset)
    print()
    calculate_pearson(dataset)
