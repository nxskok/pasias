
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n;
  vector[n] x;
vector[n] y;
  real prior_int_mean;
  real<lower=0> prior_int_sd;
  real prior_slope_mean;
  real<lower=0> prior_slope_sd;
  real<lower=0> prior_sigma_mean;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

model {
  // prior
  a ~ normal(prior_int_mean, prior_int_sd);
  b ~ normal(prior_slope_mean, prior_slope_sd);
  sigma ~ chi_square(prior_sigma_mean);
  // likelihood
  y ~ normal(a+b*x, sigma);
}

