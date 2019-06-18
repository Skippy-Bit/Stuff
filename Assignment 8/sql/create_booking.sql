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