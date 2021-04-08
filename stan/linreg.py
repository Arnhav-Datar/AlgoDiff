import pystan
import pickle
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

sns.set()  
np.random.seed(101)

model = """
data {
    int<lower=0> N;
    vector[N] x;
    vector[N] y;
}
parameters {
    real alpha;
    real beta;
    real<lower=0> sigma;
}
model {
    y ~ normal(alpha + beta * x, sigma);
}
"""

## Data and Sampling ###########################################################

# Parameters to be inferred
alpha = 2.0
beta = 3.0
sigma = 1.0

# Generate and plot data
x = 10 * np.random.rand(100)
y = alpha + beta * x
y = np.random.normal(y, scale=sigma)
plt.scatter(x, y)

plt.xlabel('$x$')
plt.ylabel('$y$')
plt.title('Scatter Plot of Data')

plt.show()

# Put our data in a dictionary
data = {'N': len(x), 'x': x, 'y': y}

sm = pystan.StanModel(model_code=model)
with open('regression_model.pkl', 'wb') as f:
    pickle.dump(sm, f)

# Train the model and generate samples
fit = sm.sampling(data=data, iter=1000, chains=1, warmup=100, thin=1, seed=101, verbose=False)
print(fit)

## Diagnostics #################################################################

summary_dict = fit.summary()
df = pd.DataFrame(summary_dict['summary'], columns=summary_dict['summary_colnames'], index=summary_dict['summary_rownames'])

alpha_mean, beta_mean = df['mean']['alpha'], df['mean']['beta']

# Extracting traces
alpha = fit['alpha']
beta = fit['beta']
sigma = fit['sigma']
lp = fit['lp__']

# Plotting regression line
x_min, x_max = -0.5, 10.5
x_plot = np.linspace(x_min, x_max, 100)

# Plot a subset of sampled regression lines
np.random.shuffle(alpha), np.random.shuffle(beta)
for i in range(len(alpha)):
  plt.plot(x_plot, alpha[i] + beta[i] * x_plot, color='lightsteelblue', 
           alpha=0.005 )

# Plot mean regression line
print(alpha_mean)
print(beta_mean)

plt.plot(x_plot, alpha_mean + beta_mean * x_plot)
plt.scatter(x, y)

plt.xlabel('$x$')
plt.ylabel('$y$')
plt.title('Fitted Regression Line')
plt.xlim(x_min, x_max)
plt.show()