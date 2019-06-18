"""
Assignment 6: Gradebook
"""

import os
from collections import defaultdict

HTML_FRAME_TOP = "<!DOCTYPE HTML>\n<html>\n<head>\n<title>{title}</title>\n" \
                 "<link rel=\"stylesheet\" href=\"{css_path}gradebook.css\"/>\n</head>\n<body>\n"
HTML_FRAME_BOTTOM = "</body>\n</html>\n"


class Student:
    def __init__(self, student_code, student_name):
        self.code = student_code
        self.name = student_name
        self.grades = defaultdict(dict)


class Gradebook(object):

    def __init__(self):
        self.__students = {}
        self.__courses = {}
        self.__semesters = defaultdict(set)

    def __create_folders(self):
        """Generates folder structure."""
        print("Generating folder structure ... ")
        for d in ["courses", "semesters", "students"]:
            os.makedirs("output/" + d, exist_ok=True)

    def __load_data(self):
        """Loads data from input tsv files."""

        # Load students
        print("Loading students.tsv ...")
        with open("students.tsv", "r") as f:
            for line in f:
                student_no, student_name = line.strip().split("\t")
                self.__students[student_no] = Student(student_no, student_name)

        # Load courses
        print("Loading courses.tsv ...")
        with open("courses.tsv", "r") as f:
            for line in f:
                course_code, course_name = line.strip().split("\t")
                self.__courses[course_code] = course_name

        # Load grades
        print("Loading grades.tsv ...")
        with open("grades.tsv", "r") as f:
            for line in f:
                student_no, course_code, semester, grade = line.strip().split("\t")
                self.__semesters[semester].add(course_code)
                self.__students[student_no].grades[course_code] = grade

    def __inCourse(self, course):
        """Counts students in a course"""
        count = 0
        for student in self.__students.values():
            if course in student.grades.keys():
                count += 1
        return count

    def __countGrade(self, course, grade):
        """Counts number of occurrences in a course"""
        count = 0
        for student in self.__students.values():
            if grade in student.grades[course]:
                count += 1
        return count

    def __generate_student_files(self):
        """Generates HTML files for students."""
        print("Generating students file ...")
        for key, student in self.__students.items():
            path = "output/students/{}.html".format(key)
            with open(path, "w") as f:
                f.write(HTML_FRAME_TOP.replace(
                    "{title}", "Gradebook Student - {student_no}").replace("{student_no}", key).replace("{css_path}", "../../"))
                f.write("<h1>Student</h1>\n<table>\n")
                f.write(
                    "<tr><td><strong>Student No:</strong></td><td>{student_no}</td></tr>\n".replace("{student_no}", key))
                f.write("<tr><td><strong>Name:</strong></td><td>{student_name}</td></tr>\n".replace(
                    "{student_name}", student.name))
                f.write("</table><br />\n")
                f.write(
                    "<table>\n<thead>\n<tr><th>Course code:</th><th>Name</th><th>Grade</th></tr>\n</thead>\n<tbody>\n")
                for semester, course in self.__semesters.items():
                    if course.intersection(set(student.grades.keys())):
                        f.write(
                            "<tr><td colspan=\"3\"><em>Semester {no}</em></td></tr>\n".replace("{no}", semester))
                        for code in sorted(course):
                            if code in student.grades.keys():
                                grade = student.grades[code]
                                name = self.__courses[code]
                                row = "<tr><td>{}</td><td>{}</td><td>{}</td></tr>\n"
                                f.write(row.format(code, name, grade))
                f.write(HTML_FRAME_BOTTOM)

    def __generate_course_files(self):
        """Generates HTML files for courses."""
        print("Generating courses file ...")
        for course_code, course_name in self.__courses.items():
            path = "output/courses/{course_code}.html".replace(
                "{course_code}", course_code)
            with open(path, "w") as f:
                f.write(HTML_FRAME_TOP.replace(
                    "{title}", "Gradebook Course - {course_code}").replace("{course_code}", course_name).replace("{css_path}", "../../"))
                header = "<h1>Course {code}</h1><h2>{name}</h2>\n"
                f.write(header.replace("{code}", course_code).replace(
                    "{name}", course_name))
                f.write(
                    "<table>\n<thead>\n<tr><th>Student No</th><th>Grade</th></tr>\n</thead>\n<tbody>\n")
                for student in self.__students.values():
                    if course_code in student.grades.keys():
                        code = student.code
                        name = student.grades[course_code]
                        row = "<tr><td>{}</td><td>{}</td></tr>\n"
                        f.write(row.format(code, name))
                f.write("</tbody>\n</table>\n")
                f.write(
                    "<h3>Summary</h3>\n<table>\n<thead>\n<tr><th>Grade</th><th>Count</th></tr>\n</thead>\n<tbody>\n")
                # for grade in course
                for grade in ["A", "B", "C", "D", "E", "F"]:
                    count = self.__countGrade(course_code, grade)
                    if count > 0:
                        row = "<tr><td>{}</td><td>{}</td></tr>\n"
                        f.write(row.format(grade, count))
                f.write("</tbody>\n</table>\n")
                f.write(HTML_FRAME_BOTTOM)

    def __generate_semester_files(self):
        """Generates HTML files for semesters."""
        print("Generating semesters file ...")
        for semester, courses in self.__semesters.items():
            path = "output/semesters/{semester}.html".replace(
                "{semester}", semester)
            with open(path, "w") as f:
                f.write(HTML_FRAME_TOP.replace(
                    "{title}", "Gradebook Semesters").replace("{css_path}", "../../"))
                f.write(
                    "<h1>Semester {semester}</h1>\n".replace("{semester}", semester))
                f.write(
                    "<table>\n<thead>\n<tr><th>Course Code</th><th>Name</th><th>#Students</th></tr>\n</thead>\n<tbody>")
                for course in sorted(courses):
                    cname = self.__courses[course]
                    incourse = self.__inCourse(course)
                    row = "<tr><td>{code}</td><td>{name}</td><td>{num}</td></tr>\n"
                    f.write(row.replace("{code}", course).replace(
                        "{name}", cname).replace("{num}", str(incourse)))
                f.write("</tbody>\n</table>\n")
                f.write(HTML_FRAME_BOTTOM)

    def __generate_index_file(self):
        """Generates the index HTML file."""
        print("Generating index file ...")
        with open("output/index.html", "w") as f:
            f.write(HTML_FRAME_TOP.replace(
                "{title}", "Gradebook Index").replace("{css_path}", "../"))

            # list of students
            f.write("<h2>Students</h2>")
            f.write(
                "<table>\n<thead>\n<tr><th>Student No</th><th>Name</th></tr>\n</thead>\n<tbody>\n")
            for key, student in sorted(self.__students.items()):
                row = "<tr><td><a href=\"students/{student_no}.html\">{student_no}</a></td><td>{student_name}</td></tr>\n"
                f.write(row.replace("{student_no}",
                                    student.code).replace("{student_name}", student.name))
            f.write("</tbody>\n</table>\n")

            # list of courses
            f.write("<h2>Courses</h2>")
            f.write(
                "<table>\n<thead>\n<tr><th>Course Code</th><th>Course Name</th></tr>\n</thead>\n<tbody>\n")
            for course_code, course_name in sorted(self.__courses.items()):
                row = "<tr><td><a href=\"courses/{course_code}.html\">{course_code}</a></td><td>{course_name}</td></tr>\n"
                f.write(row.replace("{course_code}", course_code).replace(
                    "{course_name}", course_name))
            f.write("</tbody>\n</table>\n")

            # list of semesters
            f.write("<h2>Semesters</h2>")
            f.write(
                "<table>\n<thead>\n<tr><th>Semester</th><th>Courses</th></tr>\n</thead>\n<tbody>\n")
            for semester, courses in sorted(self.__semesters.items()):
                row = "<tr><td><a href=\"semesters/{semester}.html\">{semester}</a></td>"
                f.write(row.replace("{semester}", semester))
                for course in sorted(courses):
                    row = "<td><a href=\"courses/{course_code}.html\">{course_code}</a></td>"
                    f.write(row.replace("{course_code}", course))
                f.write("</tr>\n")
            f.write("</tbody>\n</table>\n")

            f.write(HTML_FRAME_BOTTOM)

    def generate_files(self):
        self.__create_folders()
        self.__load_data()
        self.__generate_student_files()
        self.__generate_course_files()
        self.__generate_semester_files()
        self.__generate_index_file()


def main():
    gradebook = Gradebook()
    gradebook.generate_files()


if __name__ == '__main__':
    main()
