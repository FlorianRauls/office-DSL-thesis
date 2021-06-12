import odsl
import dsl       






############################ ODSL Sytax Showcase #################################



var sheet = spreadsheet:
    setName:
        "Organization"

    header:
        "Name" | "Age" | "E-Mail" | "Salary"
    
    values:
        "Max Maxson" | 35 | "example@mail-address.de" | 3782.35
        "Jennifer Jennifson" | 22 | "also@mail-address.de" | 10783.00
        "Christine Christensen" | 45 | "beispiel@mail-address.de" | 35.89
        "Karl Karlson" | 27 | "definitiv_eine_mail_adresse@mail-address.de" | 6472.91



sheet.show()


##################################################################################







#[
# OPEN SYNTAX GOALS:
Table:
    name | date | e-mail from 'real_file.xlsx'

Table:
    for name | date | e-mail in table   
]#