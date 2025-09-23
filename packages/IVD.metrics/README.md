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

Install the package directly from GitHub using:

```r
devtools::install_github("jnpmedi/MTNG_Biostat_R",subdir="packages/IVD.metrics")
```

or

```r
remotes::install_github("jnpmedi/MTNG_Biostat_R",subdir="packages/IVD.metrics")
```

---

## 💡 Example Usage
추후 example data 추가 등, 예제 코드 작성을 위한 요소들이 준비되면 해당 부분 작성 예정

```r
library(IVD.metrics)
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
  predicted,
  score,
  ci_method_auc="delong",
  alpha=0.05,
  boot_n=2000)
```

**Arguments:**
* actual: the true class label of each observation
* predicted: the predicted class label
* score: the prediction score
* ci_method_auc: method for CI of AUC (e.g., delong, bootstrap) (default = delong)
* alpha: significance level (default = 0.05)
* boot_n: number of iteration for bootstrap sampling (default = 2000)

## 📬 Contact

* Author: Youngho Cha
* Email: cswer123@naver.com
