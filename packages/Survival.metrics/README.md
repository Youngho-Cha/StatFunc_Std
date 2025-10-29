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

### Step 3: Load and Use Package Functions
The functions are located in sub-folders within the packages/ directory. To use them in your script, you must load them directly from their source folder using `devtools::load_all()`.
```r
devtools::load_all(path="packages/Survival.metrics")
```

Do not use `library()`, as we are loading the code directly, not an installed package.

---

## 💡 Example Usage
추후 example data 추가 등, 예제 코드 작성을 위한 요소들이 준비되면 해당 부분 작성 예정
```r

```

---

## ⚙️ Functions

### 🔹 1. `calc_surv_rate()`

Calculate the survival rate for the event and test difference in survival rates by group.

**Usage:**
```r
calc_surv_rate(
  time_event,
  time_follow,
  censored,
  class)
```

**Arguments:**
* time_event: The time elapsed until an event occurs
* time_follow: Follow-up period
* censored: Whether censoring occurred(0:censored, 1:event)
* class: Group separation criteria variable

### 🔹 2. `create_surv_plot()`

Create Kaplane-Meier survival plot.

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
* km_res: Results of Kaplan-Meier method
* filepath: The file location where the survival curve will be saved
* title: The title of the survival curve
* x: The name of the x-axis
* y: The name of the y-axis

### 🔹 3. `calc_freq_rate()`

Calculate event frequency and rate per group.

**Usage:**
```r
calc_freq_rate(
  time_event,
  time_vector,
  censored,
  class)
```

**Argument:**
* time_event: The time elapsed until an event occurs
* time_vector: A predefined time interval
* censored: Whether censoring occurred(0:censored, 1:event)
* class: Group separation criteria variable

### 🔹 4. `calc_hazard_ratio()`

Calculate the hazard ratio for the event by group.

**Usage:**
```r
calc_hazard_ratio(
  time_event,
  censored,
  class)
```

**Arguments:**
* time_event: The time elapsed until an event occurs
* censored: Whether censoring occurred(0:censored, 1:event)
* class: Group separation criteria variable

### 🔹 5. `calc_rmst()`

Calculate RMST for the event by group.

**Usage:**
```r
calc_rmst(
  time_event,
  time_follow,
  censored,
  class)
```

**Arguments:**
* time_event: The time elapsed until an event occurs
* time_follow: Follow-up period
* censored: Whether censoring occurred(0:censored, 1:event)
* class: Group separation criteria variable

### 🔹 6. `calc_c_index()`

Calculate C-index for the specific variables.

**Usage:**
```r
calc_c_index(
  time_event,
  censored,
  var_name)
```

**Arguments:**
* time_event: The time elapsed until an event occurs
* censored: Whether censoring occurred(0:censored, 1:event)
* var_name: Variable used to calculate the C-index

---

## 📬 Contact

* Author: Youngho Cha
* Email: cswer123@naver.com
