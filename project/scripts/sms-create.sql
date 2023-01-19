DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table faculty (
	id varchar(8) not null,
	name varchar(100),
	location varchar(35),
	constraint pk_faculty primary key (id)
);

create table lecturer (
	id char(12) not null,
	first_name varchar(35),
	last_name varchar(35),
	gender char(1),
	birthday date,
	status boolean,
	join_date date,
	address varchar(70),
	email varchar(35),
	phone varchar(12),
	faculty_id varchar(8),
	constraint pk_lecturer primary key (id),
	constraint ck_lecturer_gender check (gender in ('F', 'M'))
);

create table program (
	id char(6) not null,
	code varchar(8),
	name varchar(100),
	credit_price integer,
	faculty_id varchar(8),
	constraint pk_program primary key (id),
	constraint ck_program_credit_price check ((credit_price >= 0))
);

create table student (
	id char(8) not null,
	first_name varchar(35),
	last_name varchar(35),
	gender char(1),
	birthday date,
	status boolean,
	join_date date,
	address varchar(70),
	email varchar(35),
	phone varchar(12),
	cpa numeric(3, 2),
	gpa numeric(3, 2),
	credit_debt integer,
	tutition_debt integer,
	program_id char(6),
	constraint pk_student primary key (id),
	constraint ck_student_gender check (gender in ('F', 'M')),
	constraint ck_student_cpa check (cpa >= 0 and cpa <= 4),
	constraint ck_student_gpa check (gpa >= 0 and gpa <= 4),
	constraint ck_student_credit_debt check (credit_debt >= 0)
);

create table subject (
	id char(6) not null,
	name varchar(100),
	study_credits integer,
	tutition_credits integer,
	final_weight numeric(3, 2),
	prerequisite_id char(6),
	faculty_id varchar(8),
	constraint pk_subject primary key (id),
	constraint ck_student_study_credits check (study_credits >= 0),
	constraint ck_student_tutition_credits check (tutition_credits >= 0),
	constraint ck_subject_final_weight check (final_weight >= 0 and final_weight <= 1)
);

create table class (
	id char(6) not null,
	type char(3),
	semester char(5),
	start_time time,
	end_time time,
	weekday char(3),
	study_weeks varchar(35),
	location varchar(20),
	current_cap integer,
	max_cap integer,
	company_id char(6),
	lecturer_id char(12),
	subject_id char(6),
	constraint pk_class primary key (id),
	constraint unq_company_id unique (company_id),
	constraint ck_class_type check (type in ('LEC', 'PRA', 'LAB')),
	constraint ck_class_start_time check (start_time < end_time),
	constraint ck_class_weekday check (weekday in ('MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN')),
	constraint ck_class_current_cap check (current_cap >= 0 and current_cap <= max_cap)
);

create table curriculum (
	program_id char(6) not null,
	subject_id char(6) not null,
	constraint pk_curriculum primary key (program_id, subject_id)
);

create table enrollment (
	student_id char(8) not null,
	class_id char(6) not null,
	midterm_score integer,
	final_score integer,
	absent_count integer,
	constraint pk_enrollment primary key (student_id, class_id),
	constraint ck_enrollment_midterm_score check (midterm_score >= 0 and midterm_score <= 10),
	constraint ck_enrollment_final_score check (final_score >= 0 and final_score <= 10),
	constraint ck_enrollment_absent_count check (absent_count >= 0)
);

create table specialization (
	lecturer_id char(12) not null,
	subject_id char(6) not null,
	constraint pk_specialization primary key (lecturer_id, subject_id)
);

alter table class
add constraint fk_class_class foreign key (company_id) references class(id);

alter table class
add constraint fk_class_subject foreign key (subject_id) references subject(id);

alter table class
add constraint fk_class_lecturer foreign key (lecturer_id) references lecturer(id);

alter table curriculum
add constraint fk_curriculum_subject foreign key (subject_id) references subject(id);

alter table curriculum
add constraint fk_curriculum_program foreign key (program_id) references program(id);

alter table enrollment
add constraint fk_enrollment_student foreign key (student_id) references student(id);

alter table enrollment
add constraint fk_enrollment_class foreign key (class_id) references class(id);

alter table lecturer
add constraint fk_lecturer_faculty foreign key (faculty_id) references faculty(id);

alter table program
add constraint fk_program_faculty foreign key (faculty_id) references faculty(id);

alter table specialization
add constraint fk_specialization_lecturer foreign key (lecturer_id) references lecturer(id);

alter table specialization
add constraint fk_specialization_subject foreign key (subject_id) references subject(id);

alter table student
add constraint fk_student_program foreign key (program_id) references program(id);

alter table subject
add constraint fk_subject_faculty foreign key (faculty_id) references faculty(id);

alter table subject
add constraint fk_subject_subject foreign key (prerequisite_id) references subject(id);