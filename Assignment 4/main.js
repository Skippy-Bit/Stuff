var contacts = [];
var filtertextval = '';
var order = false;

class Entry {
    constructor(name, phone, email) {
        this.name = name;
        this.phone = phone;
        this.email = email;
    }

    toString() {
        return `\n${this.name} - ${this.phone} - ${this.email}`
    }
}
function togglesort() {
    var filtertypeselect = document.querySelector('#filtertype');
    var option = filtertypeselect.options[filtertypeselect.selectedIndex].value;
    if (option != '') {
        order = !order;
        contacts.sort(function (a, b) {
            if (option === "name") {
                const x = a.name.toLowerCase();
                const y = b.name.toLowerCase();
                return (order ? x > y : x < y);
            } else if (option === "phone") {
                const x = a.phone.toLowerCase();
                const y = b.phone.toLowerCase();
                return (order ? x > y : x < y);
            } else if (option === "email") {
                const x = a.email.toLowerCase();
                const y = b.email.toLowerCase();
                return (order ? x > y : x < y);
            }
        });
        filter();
    }
}

function draw(entry, key) {
    var html = `<div class="contact-item">
    Name: ${entry.name}<br>
    Phone: ${entry.phone}<br>
    Email: <a href="mailto:${entry.email}">${entry.email}</a>
    <div class="contact-buttons">
    <button onclick="removeContact(${key})">
    <i class="far fa-trash-alt"></i>
    </button>
    <br>
    <button onclick="editContact(${key})">
    <i class="far fa-edit"></i>
    </button>
    </div>
    </div>`;
    return html;
}

function redraw(list) {
    let contactlist = document.querySelector('.contactlist');
    if (list.length > 0) {
        contactlist.innerHTML = '<div id="entries"></div>';
        list.forEach(function (entry, i) {
            let html = draw(entry, i);
            document.querySelector('#entries').innerHTML += html;
        });
    } else {
        if (contacts.length == 0) {
            contactlist.innerHTML = '<div>You have no contacts.</div>';
        } else {
            contactlist.innerHTML = '<div>You have no matching contacts.</div>';
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    contacts.push(
        new Entry("Don John", "12322622", "don.john@something.com"),
        new Entry("John Smith", "13585415", "don.john@example.com"),
        new Entry("Stan Lee", "42912220", "stanlee@marvel.com"),
        new Entry("Bengt Ågesson", "58704768", "don.john@example.com"),
        new Entry("Test 1", "58704768", ""),
        new Entry("Test 2", "", "don.john@example.com"),
    );

    filter();

    var filterText = document.getElementById("filterText")
    filterText.addEventListener('input', function (e) {
        filtertextval = e.target.value;
        filter();
    })
});

function removeContact(key) {
    if (confirm("Do you want to delete this entry?")) {
        contacts.splice(key, 1);
        filter();
    }
}

function editContact(key) {
    let entry = contacts[key];
    alert("feature not added");

}

function addnew() {
    var name = document.querySelector('#newname').value;
    var phone = document.querySelector('#newphone').value;
    var email = document.querySelector('#newemail').value;

    var validphone = (phone != '' && validatePhone(phone));
    var validemail = (email != '' && validateEmail(email));

    if (name != '') {
        if (validemail && validphone) {
            contacts.push(
                new Entry(name, phone, email)
            );
            filter();
        } else if (phone == '' && validemail) {
            contacts.push(
                new Entry(name, phone, email)
            );
            filter();
        } else if (email == '' && validphone) {
            contacts.push(
                new Entry(name, phone, email)
            );
            filter();
        } else {
            alert("E-Mail or phone number is not valid")
        }
    } else {
        alert("Name is missing")
    }
}

function toggle_visibility(id) {
    var e = document.getElementById(id);
    if (e.style.display === 'block') {
        e.style.display = 'none';
    } else {
        e.style.display = 'block';
    }
}

function filter() {
    var list = contacts;
    if (filtertextval != null && filtertextval != '') {
        var filtertype = '';

        var filtertypeselect = document.querySelector('#filtertype');
        var option = filtertypeselect.options[filtertypeselect.selectedIndex].value;
        if (option != '') {
            filtertype = option;
        }


        list = list.filter(function (e) {
            if (filtertype == "name") {
                console.log(filtertextval);
                return e.name.toLowerCase().includes(filtertextval.toLowerCase());
            } else if (filtertype == "phone") {
                return e.phone.toLowerCase().includes(filtertextval.toLowerCase());
            } else if (filtertype == "email") {
                return e.email.toLowerCase().includes(filtertextval.toLowerCase());
            } else {
                return e;
            }
        });
    }
    redraw(list);

}

function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/i;
    return re.test(String(email).toLowerCase());
}

function validatePhone(phone) {
    var re = /^(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?$/i;
    return re.test(String(phone));

}

