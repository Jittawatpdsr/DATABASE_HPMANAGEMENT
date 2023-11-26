CREATE TABLE DEPARTMENT (
    dept_id CHAR(5) NOT NULL ,
    dept_name VARCHAR(10) NOT NULL ,
    PRIMARY KEY (dept_id)
);

CREATE TABLE MEDICAL_STAFF (
    staff_id CHAR(10) NOT NULL , 
    national_id CHAR(13) NOT NULL ,
    first_name VARCHAR(20) NOT NULL ,
    last_name VARCHAR(20) NOT NULL ,
    date_of_birth DATE NOT NULL ,
    gender CHAR(1) NOT NULL ,
    contact VARCHAR(10) NOT NULL ,
    address VARCHAR(60) NOT NULL ,
    blood_type VARCHAR(2) NOT NULL ,
    PRIMARY KEY (staff_id) ,
    dept_id CHAR(5) FOREIGN KEY REFERENCES DEPARTMENT(dept_id)
);

CREATE TABLE PATIENT (
    patient_id CHAR(10) NOT NULL ,
    national_id CHAR(13) NOT NULL ,
    first_name VARCHAR(20) NOT NULL , 
    last_name VARCHAR(20) NOT NULL , 
    date_of_birth DATE NOT NULL , 
    gender CHAR(1) NOT NULL , 
    contact VARCHAR(10) NOT NULL , 
    address VARCHAR(60) NOT NULL ,
    blood_type VARCHAR (2) NOT NULL ,
    nationality VARCHAR(10) NOT NULL ,
    allergies VARCHAR(50),
    PRIMARY KEY(patient_id)
);

CREATE TABLE MEDICATIONS_TYPE (
  type_id CHAR(1) NOT NULL ,
  type_name VARCHAR(15) NOT NULL ,
  PRIMARY KEY (type_id)
);

CREATE TABLE MEDICATIONS_INFO (
  medication_id CHAR(6) NOT NULL , 
  med_name VARCHAR(15) NOT NULL , 
  med_supplier VARCHAR(15) NOT NULL ,
  med_price INT NOT NULL , 
  med_qoh VARCHAR(10) NOT NULL ,
  exp DATE NOT NULL ,
  PRIMARY KEY (medication_id) ,
  type_id CHAR(1) FOREIGN KEY REFERENCES MEDICATIONS_TYPE(type_id)
);

CREATE TABLE MEDICAL (
  medical_id CHAR(6) NOT NULL ,
  medical_use_qty SMALLINT ,
  PRIMARY KEY ( medical_id ) , 
  medication_id CHAR(6) FOREIGN KEY REFERENCES MEDICATIONS_INFO(medication_id)
);

CREATE TABLE APPOINTMENT (
  appointment_id CHAR(5) NOT NULL ,
  appt_date DATETIME NOT NULL ,
  appt_location VARCHAR(10) NOT NULL ,
  appt_detail VARCHAR(50) NOT NULL ,
  appt_status CHAR(1) NOT NULL ,
  PRIMARY KEY (appointment_id) ,
  staff_id CHAR(10) FOREIGN KEY REFERENCES MEDICAL_STAFF(staff_id) ,
  patient_id CHAR(10) FOREIGN KEY REFERENCES PATIENT(patient_id)
);

CREATE TABLE TREATMENT (
  treatment_id CHAR(6) NOT NULL ,
  treatname VARCHAR(20) NOT NULL ,
  treat_description VARCHAR(200) NOT NULL ,
  treat_price DECIMAL(10,2) NOT NULL ,
  PRIMARY KEY (treatment_id) ,
  medication_id CHAR(6) FOREIGN KEY REFERENCES MEDICATIONS_INFO(medication_id)
);

CREATE TABLE TREATMENTRECORD (
  record_id CHAR(6) NOT NULL , 
  treatmentdate DATE NOT NULL ,
  remark VARCHAR(200) ,
  PRIMARY KEY (record_id) ,
  staff_id CHAR(10) FOREIGN KEY REFERENCES MEDICAL_STAFF(staff_id) ,
  patient_id CHAR(10) FOREIGN KEY REFERENCES PATIENT(patient_id) ,
  medical_id CHAR(6) FOREIGN KEY REFERENCES MEDICAL(medical_id) ,
  treatment_id CHAR(6) FOREIGN KEY REFERENCES TREATMENT(treatment_id)
);

CREATE TABLE LINE (
    line_no CHAR(4) NOT NULL , 
    line_price DECIMAL(10,2) NOT NULL , 
    line_amount DECIMAL(10,2) NOT NULL ,
    PRIMARY KEY(line_no) ,
    record_id CHAR(6) FOREIGN KEY REFERENCES TREATMENTRECORD(record_id)
);

CREATE TABLE INVOICE (
    invoice_id CHAR(8) NOT NULL ,
    invoice_date DATE NOT NULL , 
    invoice_amount DECIMAL(10,2) NOT NULL , 
    invoice_status CHAR(1) NOT NULL , 
    PRIMARY KEY(invoice_id) ,
    line_no CHAR(4) FOREIGN KEY REFERENCES LINE(line_no)
);

/* Function */
SELECT  INVOICE.invoice_date AS DATE, PATIENT.first_name AS 'Firstname' , PATIENT.last_name AS 'Lastname' ,
TREATMENT.treatname AS 'Treatname'  , INVOICE.invoice_amount AS 'TotalPrice' , TREATMENTRECORD.remark AS 'Remark' ,
INVOICE.invoice_status AS 'Status'
FROM TREATMENTRECORD 

INNER JOIN PATIENT ON TREATMENTRECORD.patient_id = PATIENT.patient_id
INNER JOIN TREATMENT ON TREATMENTRECORD.treatment_id = TREATMENT.treatment_id
LEFT JOIN LINE ON TREATMENTRECORD.record_id = LINE.record_id
LEFT JOIN INVOICE ON LINE.line_no = INVOICE.line_no
WHERE INVOICE.invoice_id = 'INV00004' ;

/* Function */
SELECT PATIENT.patient_id AS 'PatientID' , PATIENT.first_name AS 'Firstname' , PATIENT.last_name AS 'Lastname' , PATIENT.contact AS 'Contact' , 
TREATMENTRECORD.treatmentdate AS 'TreatmentDate' , TREATMENT.treatname AS 'TreatmentName' , MEDICAL_STAFF.first_name AS 'StaffName'
FROM PATIENT
INNER JOIN TREATMENTRECORD ON PATIENT.patient_id = TREATMENTRECORD.patient_id
INNER JOIN TREATMENT ON TREATMENTRECORD.treatment_id = TREATMENT.treatment_id
INNER JOIN MEDICAL_STAFF ON TREATMENTRECORD.staff_id = MEDICAL_STAFF.staff_id
WHERE PATIENT.patient_id = 'PT00000003';

/* Function */
SELECT PATIENT.first_name AS 'Firstname' , PATIENT.last_name AS 'Lastname' , APPOINTMENT.appt_date AS 'AppointmentDate' ,
APPOINTMENT.appt_location AS 'Location' , APPOINTMENT.appt_detail  AS 'AppointmentDetail' , MEDICAL_STAFF.first_name AS 'StaffName'
FROM PATIENT
INNER JOIN APPOINTMENT on PATIENT.patient_id = APPOINTMENT.patient_id
INNER JOIN MEDICAL_STAFF ON APPOINTMENT.staff_id = MEDICAL_STAFF.staff_id
WHERE PATIENT.patient_id = 'PT00000004';

/* Function */
SELECT MEDICAL_STAFF.staff_id ,MEDICAL_STAFF.first_name , MEDICAL_STAFF.last_name , DEPARTMENT.dept_name
From MEDICAL_STAFF

INNER JOIN DEPARTMENT On MEDICAL_STAFF.dept_id = DEPARTMENT.dept_id
WHERE MEDICAL_STAFF.dept_id = 'DP004';

/* Function */
SELECT MEDICATIONS_INFO.medication_id  AS 'MED ID'  , MEDICATIONS_INFO.med_name AS 'MED NAME' from MEDICATIONS_INFO
INNER JOIN MEDICATIONS_TYPE ON MEDICATIONS_INFO.type_id = MEDICATIONS_TYPE.type_id
WHERE type_name = 'Drug';

/* Function */
SELECT patient_id AS 'PAIENT ID', national_id AS 'NATIONAL ID', first_name AS 'FIRSTNAME',
last_name AS 'LASTNAME', date_of_birth AS 'DATE OF BIRTH', gender AS 'GENDER', contact AS 'CONTACT', address AS 'ADDRESS',
blood_type AS 'BLOOD TYPE', nationality AS 'NATIONALITY', allergies AS 'ALLERGIES'
FROM PATIENT WHERE patient_id = 'PT00000004'

/* Function */
CREATE VIEW DEBTREPORT AS
SELECT invoice_id , invoice_date , invoice_amount
FROM INVOICE
WHERE invoice_status = 'F'; 

SELECT SUM(invoice_amount) AS DEBTREPORT
FROM DEBTREPORT
WHERE MONTH(invoice_date) = 11 AND YEAR(invoice_date) = 2023;

/* Function */
SELECT med_name,exp AS 'EXP/EXD'
from MEDICATIONS_INFO
order by exp ASC

/* Function */
SELECT DEPARTMENT.dept_name , MAX(invoice_amount) 
FROM INVOICE 
INNER JOIN Line ON INVOICE.line_no = LINE.line_no 
INNER JOIN TREATMENTRECORD ON LINE.record_id = TREATMENTRECORD.record_id 
INNER JOIN MEDICAL_STAFF ON TREATMENTRECORD.staff_id = MEDICAL_STAFF.staff_id 
INNER JOIN DEPARTMENT ON MEDICAL_STAFF.dept_id = DEPARTMENT.dept_id GROUP BY(dept_name)

/* Function */
SELECT DISTINCT invoice_date, invoice_amount AS max_invoice_amount
FROM INVOICE
WHERE MONTH(invoice_date) = 11 AND YEAR(invoice_date) = 2023
  AND invoice_amount = (
  SELECT MAX(invoice_amount)
  FROM INVOICE
  WHERE MONTH(invoice_date) = 11 AND YEAR(invoice_date) = 2023
  );


