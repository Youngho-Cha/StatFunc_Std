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

## 📥 Installation

Before download package, You need to authenticate with GitHub using a Personal Access Token (PAT). This is a one-time setup that will allow devtools to securely access and install the package. 

### Step 1: Create a GitHub Personal Access Token (PAT)
1. Log in to GitHub and navigate to your <span style="color:red;">Settings</span>.
2. In the left sidebar, click Developer settings, then Personal access tokens.
3. Click Generate new token.
4. Token Scopes: Select a descriptive name for the token (e.g., R-package-access) and set an expiration date. Crucially, under "Select scopes," check the     box for repo. This is the minimum permission required to install a private repository.
5. Click Generate token.
6. Copy the token immediately. GitHub will only show you the token once. Save it in a secure location (e.g., a password manager).

### Step 2: Configure R to Use the PAT
For a seamless experience, you should store your PAT as a GITHUB_PAT environment variable in your R session. This only needs to be done once per machine.

**Method A: For a Permanent Setup (Recommended)**
Use the usethis package to automatically set up the environment variable.
1. Install usethis if you don't have it:
```r
install.packages("usethis")
```
2. Open the .Renviron file using this command. This file is loaded automatically by R at startup.
```r
usethis::edit_r_environ()
```
3. Add the following line to the file, replacing "your_personal_access_token_here" with the token you copied in Step 1:
4. GITHUB_PAT="your_personal_access_token_here"
5. Save the file and restart your R session.

**Method B: For a Temporary, One-Time Session**
If you prefer not to set up the token permanently, you can set it for the current R session only.

```r
Sys.setenv(GITHUB_PAT = "your_personal_access_token_here")
```

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
