// Colors
String[] productColors  = ['blue', 'green', 'red','yellow','purple','black','white'];
int      productColorsIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, productColors.size());

// Availability
String[] productAvail  = ['in stock', 'available', 'available for order','preorder'];
int      productAvailIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, productAvail.size());

// Brand
String[] productBrand  = ['acme', 'globex', 'soylent','initech','umbrellacorp','hooli','vehementcapital','massivedynamic'];
int      productBrandIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, productBrand.size());

// Sale Condition
String[] productCondition  = ['new', 'used', 'refurbished'];
int      productConditionIdx = org.apache.commons.lang3.RandomUtils.nextInt(0, productCondition.size());

// Product Categories
String[][] ProductCategories = [
        ["1","electronics.gps"],
        ["2","home.decor.modern"],
        ["3","movies.scifi"],
        ["4","books.fantasy"],
        ["5","tools.wrenches"],
        ["6","sports.hockey"],
        ["7","baby.diapers"],
        ["8","apparel.shirts"],
        ["9","beauty.moisturizer"],
        ["10","music.ska"],
        ["11","kids.toys"],
        ["12","outdoors.camping"],
        ["13","industrial.drills"],
        ["14","health.vitamins"],
        ["15","apparel.pants"],
        ["16","garden.roses"],
        ["17","health.glasses"],
        ["18","games.puzzle"],
        ["19","grocery.staples"],
        ["20","apparel.jacket"],
        ["21","automotive.tires"],
        ["22","computers.gaming"],
        ["23","appliances.kitchen.stove"],
        ["24","baby.playpens"],
        ["25","pets.food"], 
        ["26","electronics.smartphone"], 
        ["27","computers.notebook"], 
        ["28","construction.tools.drill"], 
        ["29","furniture.kitchen.chair"], 
        ["30","electronics.audio.headphone"], 
        ["31","computers.desktop"], 
        ["32","furniture.bedroom.bed"], 
        ["33","appliances.sewing_machine"],
        ["34","auto.accessories.player"],
        ["35","furniture.livingroom.sofa"],
        ["36","auto.accessories.player"],
        ["37","electronics.audio.subwoofer"],
        ["38","industrial.planers"],
        ["39","apparel.jeans"],
        ["40","appliances.kitchen.refrigerators"],
        ["41","apparel.shoes"],
        ["42","electronics.video.tv"],
        ["43","sport.bicycle"],
        ["44","electronics.clocks"],
        ["45","home.flooring"],
        ["46","garden.tools"],
        ["47","appliances.laundry"],
        ["48","health.allergies"],
        ["49","furniture.office.desk"]      
    ];
int ProductCategoriesIdx = org.apache.commons.lang3.RandomUtils.nextInt(0,ProductCategories.size());

// Price & Sale Price
Random random = new Random();  // Only one instance needed.
double priceDbl = random.nextInt(100000) / 100.0;
double discount = random.nextInt(30);
double salePriceDbl = priceDbl;

if (discount >= 5.0) {
    salePriceDbl = priceDbl - (priceDbl / discount);
}

// Add variables to jMeter
vars.put('mockValues.productPrice', String.format("%.2f", priceDbl));
vars.put('mockValues.productSalePrice', String.format("%.2f", salePriceDbl));
vars.put('mockValues.productCategory', ProductCategories[ProductCategoriesIdx][0]);
vars.put('mockValues.productCategoryCode', ProductCategories[ProductCategoriesIdx][1]);
vars.put('mockValues.productColor', productColors[productColorsIdx]);
vars.put('mockValues.productAvail', productAvail[productAvailIdx]);
vars.put('mockValues.productBrand', productBrand[productBrandIdx]);
vars.put('mockValues.productCondition', productCondition[productConditionIdx]);
