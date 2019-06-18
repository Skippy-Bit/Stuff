"""
Assignment 8: Booking site
"""

from flask import Flask, session, request, render_template
from datetime import datetime, timedelta
# import mysql.connector
import pymysql
import re

app = Flask(__name__)
app.debug = True
app.secret_key = 'Lorem ipsum secret handball'


class Database:
    def __init__(self):
        host = "localhost"
        user = "root"
        password = "root"
        db = "booking"
        # self.con = mysql.connector.connect(
        #     user=user, password=password, host=host, database=db)
        self.con = pymysql.connect(host=host, user=user, password=password, db=db, cursorclass=pymysql.cursors.
                                   DictCursor)
        self.cursor = self.con.cursor()

    def getPropeties(self):
        self.cursor.execute("SELECT * FROM property")
        result = self.cursor.fetchall()
        return result

    def getProperty(self, property_id):
        self.cursor.execute(
            "SELECT * FROM property WHERE property_id = %s", args=(int(property_id)))
        result = self.cursor.fetchone()
        return result

    def insertBooking(self, checkin, checkout, property_id, contact_name, contact_email, contact_phone, contact_address_street, contact_address_zipcode, contact_address_city, contact_address_country, comment):
        self.cursor.execute("INSERT INTO booking (" +
                            "checkin, checkout, property_id, contact_name," +
                            "contact_email, contact_phone, contact_address_street," +
                            "contact_address_zipcode, contact_address_city," +
                            "contact_address_country, comment" +
                            ") VALUES (" +
                            "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s" +
                            ")", args=(checkin.strftime(r'%Y-%m-%d'),
                                       checkout.strftime(r'%Y-%m-%d'),
                                       int(property_id),
                                       contact_name,
                                       contact_email,
                                       contact_phone,
                                       contact_address_street,
                                       contact_address_zipcode,
                                       contact_address_city,
                                       contact_address_country,
                                       comment))
        self.con.commit()
        self.cursor.execute(
            "SELECT * FROM booking WHERE booking_id = LAST_INSERT_ID()")
        result = self.cursor.fetchone()
        return result


@app.route("/")
def index():
    """Index page that shows a list of properties"""
    db = Database()
    props = db.getPropeties()
    return render_template("index.html", props=props)


def get_property(property_id):
    """Loads a property from the database."""
    db = Database()
    prop = db.getProperty(property_id)
    return prop


@app.route("/property/<int:property_id>")
def property(property_id):
    """Product page"""
    return render_template("property.html", prop=get_property(property_id))


def remove_booking_session_variables():
    session.pop('property_id', None)
    session.pop('checkin', None)
    session.pop('nights', None)
    session.pop('checkout', None)
    session.pop('form_name', None)
    session.pop('form_email', None)
    session.pop('form_phone', None)
    session.pop('form_street_name', None)
    session.pop('form_zipcode', None)
    session.pop('form_city', None)
    session.pop('form_country', None)
    session.pop('comment', None)


def insert_booking(checkin,
                   checkout,
                   property_id,
                   contact_name,
                   contact_email,
                   contact_phone,
                   contact_address_street,
                   contact_address_zipcode,
                   contact_address_city,
                   contact_address_country,
                   comment):
    """Inserts a booking in the database."""
    db = Database()
    booking = db.insertBooking(checkin,
                               checkout,
                               property_id,
                               contact_name,
                               contact_email,
                               contact_phone,
                               contact_address_street,
                               contact_address_zipcode,
                               contact_address_city,
                               contact_address_country,
                               comment)
    return booking


@app.route("/book", methods=["POST"])
def book():
    """Booking process"""
    action = request.form.get("action")
    if action == "do_1":
        form_name = request.form.get("name").strip()
        form_email = request.form.get("email").strip()
        form_phone = request.form.get("phone").strip()
        form_street_name = request.form.get("street_name").strip()
        form_zipcode = request.form.get("zipcode").strip()
        form_city = request.form.get("city").strip()
        form_country = request.form.get("country").strip()
        form_comment = request.form.get("comment").strip()

        if (not form_name):
            form_name = ''
        if (not form_email):
            form_email = ''
        if (not form_phone or not re.match(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$', form_phone)):
            form_phone = ''
        if (not form_street_name):
            form_street_name = ''
        if (not form_zipcode):
            form_zipcode = ''
        if (not form_city):
            form_city = ''
        if (not form_country):
            form_country = ''

        if '' in [form_name, form_email, form_phone, form_street_name, form_zipcode, form_city, form_country]:
            return render_template("booking_1.html",
                                   form_name=form_name,
                                   form_email=form_email,
                                   form_phone=form_phone,
                                   form_street_name=form_street_name,
                                   form_zipcode=form_zipcode,
                                   form_city=form_city,
                                   form_country=form_country,
                                   form_comment=form_comment,
                                   err='Some information was invalid. Please enter valid information.')

        session['form_name'] = form_name
        session['form_email'] = form_email
        session['form_phone'] = form_phone
        session['form_street_name'] = form_street_name
        session['form_zipcode'] = form_zipcode
        session['form_city'] = form_city
        session['form_country'] = form_country
        session['form_comment'] = form_comment

        return render_template("booking_2.html", form_name=form_name,
                               form_email=form_email,
                               form_phone=form_phone,
                               form_street_name=form_street_name,
                               form_zipcode=form_zipcode,
                               form_city=form_city,
                               form_country=form_country,
                               form_comment=form_comment,
                               checkin=session['checkin'].strftime(
                                   r'%Y-%m-%d'),
                               nights=session['nights'],
                               checkout=session['checkout'].strftime(
                                   r'%Y-%m-%d'),
                               prop=get_property(session['property_id']))
    elif action == "do_2":
        if request.form.get("confirm") == "1":  # check if booking is confirmed
            checkin = session['checkin']
            checkout = session['checkout']
            property_id = session['property_id']
            form_name = session['form_name']
            form_email = session['form_email']
            form_phone = session['form_phone']
            form_street_name = session['form_street_name']
            form_zipcode = session['form_zipcode']
            form_city = session['form_city']
            form_country = session['form_country']
            form_comment = session['form_comment']

            booking = insert_booking(checkin, checkout, property_id, form_name,
                                     form_email, form_phone, form_street_name,
                                     form_zipcode, form_city, form_country, form_comment)

            # Cleanup session variables
            remove_booking_session_variables()

            return render_template("booking_3.html", booking=booking)
        else:
            return render_template("booking_2.html", err="You need to confirm the booking.",
                                   form_name=session['form_name'],
                                   form_email=session['form_email'],
                                   form_phone=session['form_phone'],
                                   form_street_name=session['form_street_name'],
                                   form_zipcode=session['form_zipcode'],
                                   form_city=session['form_city'],
                                   form_country=session['form_country'],
                                   form_comment=session['form_comment'],
                                   checkin=session['checkin'].strftime(
                                       r'%Y-%m-%d'),
                                   nights=session['nights'],
                                   checkout=session['checkout'].strftime(
                                       r'%Y-%m-%d'),
                                   prop=get_property(session['property_id']))
    else:
        # Remove old session variables
        remove_booking_session_variables()

        # Optionally wrap this in a try/catch statement, but I won't bother here,
        # since the browser provides enough guidance for the user to remember to
        # fill out the required field(s).
        property_id = int(request.form.get("property_id"))
        checkin = datetime.strptime(request.form.get("checkin"), r'%Y-%m-%d')
        nights = int(request.form.get("nights"))
        checkout = checkin + timedelta(days=nights)

        session['property_id'] = property_id
        session['checkin'] = checkin
        session['nights'] = nights
        session['checkout'] = checkout

        return render_template("booking_1.html",
                               property_id=property_id,
                               checkin=checkin.strftime(r'%Y-%m-%d'),
                               nights=nights,
                               checkout=checkout.strftime(r'%Y-%m-%d'))


if __name__ == "__main__":
    app.run()
