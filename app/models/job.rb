class Job < ApplicationRecord
  belongs_to :job_category
  belongs_to :user

  EMPLOYEE_TYPE = ['Full-time', 'Part-time', 'Self-Employeed', 'Freelance', 'Trainee', 'Internship']

  STATUS = [ 'Public', 'Private', 'Archieved' ]

  SALARY = [
    '₹ 5000-10000',
    '₹ 10000-15000',
    '₹ 15000-20000',
    '₹ 20000-25000',
    '₹ 25000-30000'
  ]

  QUALIFICATION = [ 'Graduation', 'Post Graduation', '12th Standard' ]

end
