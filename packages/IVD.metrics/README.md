# An R package to calculate diagnostic performance metrics for IVD clinical trials

---

## 🎯 Purpose

This package helps users compute key diagnostic performance metrics such as:

- **Sensitivity**
- **Specificity**
- **Positive Predictive Value (PPV)**
- **Negative Predictive Value (NPV)**
- **Accuracy**
- **Area Under the Curve (AUC)**

It also calculates **100(1−α)% confidence intervals** for each metric.

---

## 🔧 Setup and Usage Guide

This repository contains standardized R functions for clinical analysis, managed as a monorepo. It uses `renv` to ensure a 100% reproducible analysis environment across all packages.

This workflow is designed for internal validation and analysis, not for traditional package installation via `install_github`.

### Step 1: Clone the Repository
First, clone this repository to your local machine using Git.

```Bash
git clone https://github.com/YourOrganization/YourRepoName.git
```

### Step 2: Restore the Standardized Environment
This step installs all required dependency packages using the exact versions specified in the master renv.lock file.

1. Open the root R project in RStudio.

2. When the project opens, `renv` should automatically start. In the R console, run the following command to restore the environment:
   ```r
   renv::restore()
   ```
3. If you are prompted with a list of packages to update (like in the image you showed me), you must select the option for "None" (e.g., input "3").
   This ensures you are using the exact validated versions from the renv.lock file, which is critical for reproducibility.

### Step 3: Install the Package
Once your GITHUB_PAT environment variable is set up, you can install the package using devtools as you would with any other GitHub repository.

Install the package directly from GitHub using:
```r
# Make sure you have the devtools package installed
# install.packages("devtools")

# Install the package from this repository
devtools::install_github("jnpmedi/MTNG_Biostat_R",subdir="packages/IVD.metrics")
```

This command will automatically use the GITHUB_PAT environment variable for authentication, allowing it to access our private repository.

---

## 💡 Example Usage

* `calc_binary_metrics` 
```r
library(IVD.metrics)

data(ex_data)

## Select metrics to calculate
Ground_Truth=ex_data$gt
Predicted=ex_data$pred

res_metrics=calc_binary_metrics(actual=Ground_Truth,
                                predicted=Predicted,
                                metrics_to_calc=c("sensitivity","ppv","accuracy"))

res_metrics_sensitivity=res_metrics$sensitivity
res_metrics_ppv=res_metrics$ppv
res_metrics_accuracy=res_metrics$accuracy

## Select method for calculating confidence interval
Ground_Truth=ex_data$gt
Predicted=ex_data$pred

res_ci=calc_binary_metrics(actual=Ground_Truth,
                           predicted=Predicted,
                           metrics_to_calc=c("specificity","npv","accuracy"),
                           ci_method="wald")

res_ci_specificity=res_ci$specificity
res_ci_npv=res_ci$npv
res_ci_accuracy=res_ci$accuracy
```

* `calc_auc`
```r
library(IVD.metrics)

data(ex_data)

## Use default method for calculating confidence interval
Ground_Truth=ex_data$gt
Score=ex_data$score

res_default=calc_auc(actual=Ground_Truth,
                     score=Score)

res_default_auc=res_default$auc

## Use Bootstrap method for calculating confidence interval
Ground_Truth=ex_data$gt
Score=ex_data$score

res_bootstrap=calc_auc(actual=Ground_Truth,
                       score=Score,
                       ci_method="bootstrap",
                       boot_n=1000)

res_bootstrap_auc=res_bootstrap$auc
```

---

## ⚙️ Functions

### 🔹 1. `calc_binary_metrics`

Calculates binary performance metrics with their confidence intervals.

**Usage:**
```r
calc_binary_metrics(
  actual,
  predicted,
  metrics_to_calc=c("sensitivity","specificity","ppv","npv","accuracy"),
  ci_method="cp",
  alpha=0.05)
```

**Arguments:**
* actual: the true class label of each observation
* predicted: the predicted class label
* metrics_to_calc: which metrics to calculate (default = all metrics)
* ci_method: method for calculating confidence intervals of metrics (e.g., cp, wilson, wald) (default = Clopper-Pearson)
* alpha: significance level (default = 0.05)

### 🔹 2. `calc_auc()`

Calculate AUC(Area Under Curve) with its confidence intervals.

**Usage:**
```r
calc_auc(
  actual,
  score,
  ci_method="delong",
  alpha=0.05,
  boot_n=2000)
```

**Arguments:**
* actual: the true class label of each observation
* score: the prediction score
* ci_method: method for CI of AUC (e.g., delong, bootstrap) (default = delong)
* alpha: significance level (default = 0.05)
* boot_n: number of iteration for bootstrap sampling (default = 2000)

## 📬 Contact

* Author: Youngho Cha
* Email: cswer123@naver.com
