# An R package for calculating evaluation metrics related to survival analysis.

---

## 🎯 Purpose

This package helps to calculate the following evaluation metrics using survival analysis:

- **Survival rate**
- **Survival curve**
- **Event frequency and percentage over time**
- **Hazard ratio**
- **RMST (Restricted Mean Survival Time)**
- **C-index (Concordance Index)**

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
devtools::install_github("jnpmedi/MTNG_Biostat_R",subdir="packages/Survival.metrics")
```

This command will automatically use the GITHUB_PAT environment variable for authentication, allowing it to access our private repository.

---

## 💡 Example Usage
추후 example data 추가 등, 예제 코드 작성을 위한 요소들이 준비되면 해당 부분 작성 예정
```r
library(Survival.metrics)
```

---

## ⚙️ Functions

### 🔹 1. `calc_surv_rate()`

Calculates key performance metrics with their confidence intervals.

**Usage:**
```r
calc_surv_rate(
  time_event,
  time_follow,
  censored,
  class)
```

**Arguments:**
* time_event:
* time_follow:
* censored:
* class:

### 🔹 2. `create_surv_plot()`

Formats the numerical output of `calc_performance_metrics()` into an easy-to-read table.

**Usage:**
```r
create_surv_plot(
  km_res,
  filepath,
  title,
  x,
  y)
```

**Arguments:**
* metrics: the output from the calc_performance_metrics() function containing the calculated performance metric values

### 🔹 3. `format_for_reporting()`

Rounds numerical output values to the specified number of decimal places.

**Usage:**
```r
format_for_reporting(df, digits=3)
```

**Argument:**
* df: the data frame formatted using the format_performance_output() function
* digits: number of decimal places (default = 3)

### 🔹 4. `save_performance_report() / save_performance_report_docx()`

Saves the formatted output of `format_performance_metrics()` to a specified excel/ word file.

**Usage:**
```r
save_performance_report(results_df, original_result, outdir = "results", filename = NULL)
save_performance_report_docx(results_df, original_result, outdir = "results", filename = NULL)
```

**Arguments:**
* results_df: the tabular data formatted using the format_for_reporting() function
* original_result: the output from the calc_performance_metrics() function
* outdir: name of the output directory where the file will be saved (default = "results")
* filename: name of the output file (default = NULL)
  
---

## 📬 Contact

* Author: Youngho Cha
* Email: cswer123@naver.com
