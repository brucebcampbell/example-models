# http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/Vol1.pdf
# Page 34: Oxford: smooth fit to log-odds ratios

data {
  int<lower=0> K; 
  int<lower=0> n0[K];
  int<lower=0> n1[K]; 
  int<lower=0> r0[K]; 
  int<lower=0> r1[K]; 
  int year[K]; 
} 
transformed data {
  int yearsq[K]; 
  for (i in 1:K) 
    yearsq[i] <- year[i] * year[i]; 
} 
parameters {
  real mu[K]; 
  real alpha;
  real beta1; 
  real beta2;
  real<lower=0> sigma_sq;
  real b[K]; 
}
transformed parameters {
  real<lower=0> sigma;
  sigma <- sqrt(sigma_sq);
}
model {
  real p1[K];
  real p2[K];
  for (i in 1:K) {
    p1[i] <- inv_logit(mu[i]);
    p2[i] <- inv_logit(mu[i] + alpha + beta1 * year[i] + beta2 * (yearsq[i] - 22) + sigma * b[i]);
  } 
  r0 ~ binomial(n0, p1);
  r1 ~ binomial(n1, p2);
  b  ~ normal(0, 1);
  mu ~ normal(0, 1000); 

  alpha  ~ normal(0.0, 1000); 
  beta1  ~ normal(0.0, 1000); 
  beta2  ~ normal(0.0, 1000); 
  sigma_sq ~ inv_gamma(0.001, 0.001);
}
