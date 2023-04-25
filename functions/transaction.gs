// Number of items in loop
int items = Integer.parseInt(vars.get("txCount").trim());

// Price & Sale Price
Random random = new Random();  // Only one instance needed.
double priceDbl = random.nextInt(100000) / 100.0;
double discount = random.nextInt(30);
double salePriceDbl = priceDbl;

if (discount >= 5.0) {
    salePriceDbl = priceDbl - (priceDbl / discount);
}

double txTotalTax = salePriceDbl * 0.05;
double txTotalRevenue = salePriceDbl * 0.29;

double txPricePerItem = salePriceDbl / items;
double txTaxPerItem = txPricePerItem * 0.05;
double txRevenuePerItem = txPricePerItem * 0.29;

// Add variables to jMeter
vars.put('mockValues.txPrice', String.format("%.2f", priceDbl));
vars.put('mockValues.txSalePrice', String.format("%.2f", salePriceDbl));
vars.put('mockValues.txTax', String.format("%.2f", txTotalTax));
vars.put('mockValues.txRevenue', String.format("%.2f", txTotalRevenue));

vars.put('mockValues.txPricePerItem', String.format("%.2f", txPricePerItem));
vars.put('mockValues.txTaxPerItem', String.format("%.2f", txTaxPerItem));
vars.put('mockValues.txRevenuePerItem', String.format("%.2f", txRevenuePerItem));
