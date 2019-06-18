drop schema if exists booking;
create schema booking;
use booking;

CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    checkin DATE,
    checkout DATE,
    property_id BIGINT UNSIGNED REFERENCES property(property_id),
    contact_name VARCHAR(100),
    contact_email VARCHAR(254),
    contact_phone VARCHAR(50),
    contact_address_street VARCHAR(50),
    contact_address_zipcode VARCHAR(20),
    contact_address_city VARCHAR(50),
    contact_address_country VARCHAR(50),
    comment TEXT
);

CREATE TABLE property(
    property_id SERIAL PRIMARY KEY,
    property_name VARCHAR(50),
    property_description TEXT,
    property_details TEXT,
    property_location VARCHAR(100),
    property_photo VARCHAR(250)
);

INSERT INTO `property` (`property_name`, `property_location`, `property_description`, `property_details`, `property_photo`)
VALUES
	("Holiday home Røros", "Røros, Sør-Trøndelag", "The property features views of the sea and is 23 km from Røros.", "Vestibulum risus sem, dictum at faucibus vel, ultricies nec felis. Praesent a mattis diam. Ut sit amet lectus et orci tempor consectetur laoreet vitae leo. Mauris rutrum dolor a commodo laoreet. Mauris sollicitudin, odio id condimentum dapibus, enim arcu tincidunt elit, mollis porta tortor ligula eget metus. In eleifend luctus sapien in semper. In ornare feugiat consequat.", "property_1.png"),
    ("Oppdal Turisthotell", "Oppdal, Sør-Trøndelag", "It offers free parking and rooms with free WiFi and a private bathroom. Oppdal Ski Centre is a 10-minute walk away.", "Vivamus finibus nisl vitae justo ullamcorper pulvinar. Integer ut justo nec risus sollicitudin imperdiet. Nam tellus ante, euismod sed maximus et, mattis sed metus. Ut id condimentum sapien. Sed ex nibh, rhoncus vel efficitur in, tincidunt et odio. Suspendisse gravida lorem a lacus condimentum, ac venenatis arcu pellentesque. Phasellus at faucibus mauris. Mauris facilisis, mi et ullamcorper aliquet, sem quam tristique nulla, nec dignissim augue elit eu dui. Curabitur ac eleifend odio. Etiam at sapien justo. Nam leo purus, vulputate ut porttitor venenatis, pulvinar at odio. Nam finibus, nibh non convallis tempor, eros lacus ultrices leo, ut vestibulum nulla velit sit amet leo. Donec sodales, erat eget bibendum molestie, lorem quam fringilla leo, non malesuada urna quam non nisi.", "property_2.png"),
    ("Granmo Camping", "Røros, Sør-Trøndelag", "Granmo Camping is scenically situated in Oppdal, right by Dovrefjell National Park. Facilities include a mini-market and, a snack bar and a shared kitchen.", "Sed ac hendrerit dui, sed tincidunt erat. Duis ut malesuada lorem. Nulla venenatis vitae enim at rhoncus. Nunc vitae libero eget odio viverra congue eget et nulla. Nam vulputate risus neque, non feugiat velit malesuada et. Cras elementum, erat vel ultricies laoreet, nunc est pretium nisl, id placerat elit nisl eu massa. Pellentesque finibus nibh id leo porta cursus. Curabitur venenatis, ipsum id venenatis blandit, enim justo pulvinar ex, id ornare sem neque non tellus. Phasellus euismod eu tellus in egestas. Vivamus tempor euismod auctor. Nunc vel nunc nunc. Cras in nisl tortor. Nunc eleifend lectus ut ex malesuada, sit amet pretium dolor tempus.", "property_3.png"),
    ("Sjøberg Ferie", "Østhusvik, Rogaland", "These modern apartments are set on Rennesøy island. Boats can be rented on site.", "Morbi sit amet massa eu urna vestibulum finibus. Sed feugiat magna lorem, eget dictum augue posuere vitae. Ut ligula erat, bibendum non vestibulum id, lacinia faucibus diam. Integer eu elit dignissim, pellentesque augue eu, pellentesque metus. Vestibulum volutpat purus ligula, at scelerisque arcu aliquet sed. Praesent fermentum dolor eu quam placerat bibendum. Integer non neque leo.","property_4.png"),
    ("Holiday home Jørpeland Høllesli", "Forsand, Rogaland", "Holiday home Jørpeland Høllesli offers accommodation in Forsand, 21 km from Stavanger and 23 km from Sandnes.", "Vestibulum quis accumsan quam. Nulla eu magna vitae tortor semper vestibulum. Vestibulum laoreet ligula non eros finibus scelerisque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nunc in tellus tellus. Aliquam euismod, nisl ut mollis malesuada, elit ligula dictum quam, et sollicitudin sem eros eu sapien. Sed est est, iaculis et viverra sit amet, rhoncus sit amet risus. Praesent facilisis risus vitae diam ultrices, at hendrerit ex volutpat. Donec sed eleifend nulla. Integer at urna vitae libero consectetur congue. In dignissim massa in neque accumsan, in venenatis diam vestibulum. Suspendisse mattis lectus mollis sem imperdiet, id faucibus lacus efficitur. Fusce nisi lorem, convallis vel quam sed, sollicitudin fermentum mauris. Vestibulum lobortis, mi a commodo malesuada, sem lacus fermentum sapien, eget dictum felis ipsum vitae nisl. Vivamus laoreet dolor id imperdiet tempor. Etiam lobortis et nisi eu pretium.", "property_5.png"),
    ("Høiland Gard", "Årdal, Rogaland", "This self catering accommodation, Høiland Gard, is located 5 minutes’ drive from Årdal village. Eventyrskogen Hiking Trail is 1 km away.", "Donec porta metus vitae faucibus consequat. Donec sed arcu quis mauris maximus ultrices. Praesent in congue tortor, vel porttitor nulla. Donec id nulla in lacus posuere consequat. Etiam vitae elit et sem placerat accumsan eu vitae orci. Suspendisse vulputate scelerisque ipsum, eu varius augue ultricies eu. Ut sed ligula nec magna varius dapibus. Proin nec condimentum lacus, ut eleifend dolor.", "property_6.png");
    