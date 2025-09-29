# Hydropower Optimization

This project investigates optimization strategies for maximizing profits in **hydropower generation** by strategically planning water discharge and spillage across reservoirs. The case study focuses on *PowerCompany AB* operating four hydro plants over a 9-hour horizon, using both **linear programming (LP)** and **stochastic programming** approaches.

## Project Overview

* **Problem Type:** Linear & stochastic optimization
* **Context:** Hydropower production planning
* **Planning Horizon:** 9 hours
* **Key Features:**

  * Linear programming formulation with deterministic electricity prices
  * Sensitivity analysis of reservoir and discharge constraints
  * Consideration of future electricity prices beyond 9 hours
  * Stochastic programming to account for uncertain price scenarios

## Models

1. **Deterministic LP Model**

   * Maximizes profit using known hourly electricity prices
   * Achieves ~€1.203 billion optimal profit
   * Strategy: discharge during high-price hours, conserve water during low-price hours

2. **Extended LP Model (Future Prices)**

   * Incorporates value of selling stored water after the 9-hour horizon
   * Higher profits when future prices exceed immediate market prices

3. **Stochastic Programming Models**

   * **Expected Value (EV) Model:** average price scenario, profit ~€0.988 billion
   * **Two-Stage Recourse Model:** adaptive strategy, profit ~€1.021 billion
   * More robust performance across multiple pricing scenarios

## Results & Insights

* **Reservoir & Discharge Constraints:**

  * Relaxing minimum reservoir levels increases profit potential (e.g., +€31.15 million at Åhlen).
  * Tightening discharge limits reduces profitability (e.g., –€30.3 million at Forsen).
* **Capacity Utilization:**

  * Increasing Forsen’s discharge capacity yields the highest marginal gains.
* **Price Sensitivity:**

  * Higher future electricity prices incentivize water conservation.
* **Uncertainty Handling:**

  * Stochastic models trade off some profit for robustness under market volatility.

## Repository Structure

```
.
├── models/
│   ├── hydro_lp.gms           # Basic deterministic LP model
│   ├── hydro_future.gms       # LP with future price extension
│   ├── hydro_ev.gms           # Expected value stochastic model
│   ├── hydro_2stage.gms       # Two-stage recourse stochastic model
│
├── results/
│   ├── lp_results.txt         # Output for deterministic model
│   ├── stochastic_results.txt # Output for stochastic models
│
├── report/
│   └── Hydropower_Report.pdf  # Full academic report
│
└── README.md
```

## Usage Instructions

### Requirements

* [GAMS](https://www.gams.com/download/) with LP/NLP solvers (e.g., **CPLEX**)

### Running the Models

1. Clone the repository:

   ```bash
   git clone https://github.com/<your-username>/hydropower-optimization.git
   cd hydropower-optimization/models
   ```

2. Run the **deterministic LP model**:

   ```bash
   gams hydro_lp.gms
   ```

3. Run the **future price model**:

   ```bash
   gams hydro_future.gms
   ```

4. Run the **stochastic models**:

   ```bash
   gams hydro_ev.gms
   gams hydro_2stage.gms
   ```

5. Check results in the `results/` directory.

## Technologies

* **GAMS**: for LP and stochastic optimization models
* **Optimization Methods**: linear programming, stochastic programming
* **Sensitivity Analysis**: marginal values (shadow prices)

## Authors

* David Alm ([davialm@kth.se](mailto:davialm@kth.se))
* Lisa Björklund ([lisabjor@kth.se](mailto:lisabjor@kth.se))
* Ali Ghasemi ([aghasemi@kth.se](mailto:aghasemi@kth.se))
* Sara Tegborg ([tegborg@kth.se](mailto:tegborg@kth.se))

*KTH Royal Institute of Technology – SF2812 Applied Linear Optimization (2025)*

---

📄 This repository contains the models, results, and report analyzing hydropower generation optimization under price uncertainty.
