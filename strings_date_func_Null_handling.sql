use ecommerce;

CREATE TABLE raw_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    order_date DATE,
    delivery_date DATE,
    product_name VARCHAR(100),
    quantity INT,
    total_amount DECIMAL(10,2),
    region VARCHAR(50)
);

INSERT INTO raw_orders VALUES
(1, ' john DOE ', 'JOHN.DOE@GMAIL.COM', '123-456-7890', '2024-11-20', '2024-11-25', 'Laptop Pro 15"', 1, 1200.50, 'north'),
(2, 'PRIYA ', '   ', '9876543210', '2024-11-22', '2024-11-30', 'Wireless Mouse', 2, 40.00, 'south'),
(3, 'Amit', NULL, NULL, '2024-11-21', '1900-01-01', '4K Monitor', 1, NULL, 'EAST'),
(4, 'Riya kapoor', 'RIYA.KAPOOR@yahoo.com', '   ', '2024-11-23', '2024-11-29', 'Laptop Sleeve', 3, 90.00, 'West'),
(5, '   Alex', 'alex@gmail.com', '555-111-2222', '2024-11-20', NULL, 'Mechanical Keyboard', 1, 100.00, 'north'),
(6, NULL, 'unknown@company.com', NULL, '2024-11-22', '2024-11-27', 'Laptop Pro 15"', 2, 2400.00, 'north'),
(7, 'Sara ', 'sara@gmail.com', '999-888-7777', '2024-11-21', '2024-11-26', '4K Monitor', 2, 600.00, 'South'),
(8, 'John Doe', NULL, NULL, '2024-11-24', '2024-11-30', 'Wireless Mouse', 4, NULL, 'south'),
(9, 'sameer', 'sameer@hotmail.com', '1112223333', '2024-11-25', '2024-11-28', 'Gaming Chair', 1, 250.00, 'EAST'),
(10, 'shreya', 'shreya@company.com', '9998887776', '2024-11-23', NULL, 'Desk Lamp', 1, 80.00, 'WEST'),
(11, 'Nikita', 'nikita@GMAIL.com', NULL, '2024-11-22', '2024-11-26', 'Wireless Mouse', 2, 40.00, 'north'),
(12, '', NULL, '5555555555', '2024-11-20', '2024-11-24', 'Smart Watch', 1, 200.00, 'EAST'),
(13, 'Rahul', 'rahul@company.com', NULL, '2024-11-22', '1900-01-01', 'Laptop Pro 15"', 1, 1200.50, 'EAST'),
(14, 'Sam ', 'sam@company.com', '123-456-7890', '2024-11-22', '2024-11-27', 'Desk Lamp', 1, NULL, 'south'),
(15, 'Chris', '', '', '2024-11-24', NULL, 'Mechanical Keyboard', 1, 100.00, 'WEST'),
(16, 'Olivia', 'olivia@company.com', '9997778888', '2024-11-25', '2024-11-29', 'Smart Watch', 2, 400.00, 'EAST'),
(17, '   Raj ', 'raj@gmail.com', '   ', '2024-11-20', '2024-11-22', 'Gaming Chair', 1, 250.00, 'north'),
(18, 'Aarav', NULL, NULL, '2024-11-23', '2024-11-28', 'Desk Lamp', 3, 240.00, 'south'),
(19, 'Tina', 'Tina@company.com', NULL, '2024-11-25', NULL, 'Laptop Sleeve', 2, 60.00, 'west'),
(20, 'Ben', '   ', ' ', '2024-11-24', '2024-11-28', 'Laptop Pro 15"', 1, 1200.50, 'north');

select * from raw_orders;

-- String Functions 
--  Clean extra spaces from customer_name
  select TRIM(customer_name) from raw_orders;
  
-- Convert all customer_name to proper case
select 
       concat(
       upper(left(trim(customer_name), 1)),
       lower(substring(trim(customer_name),2))) as name
from raw_orders;

-- For Two-Word Names

select
     CONCAT(
        UPPER(LEFT(TRIM(SUBSTRING_INDEX(customer_name, ' ', 1)), 1)),
        LOWER(SUBSTRING(TRIM(SUBSTRING_INDEX(customer_name, ' ', 1)), 2)),
        ' ',
        UPPER(LEFT(TRIM(SUBSTRING_INDEX(customer_name, ' ', -1)), 1)),
        LOWER(SUBSTRING(TRIM(SUBSTRING_INDEX(customer_name, ' ', -1)), 2))
    ) AS proper_name
from raw_orders;
     
-- Make all emails lowercase
select
         email,
         lower(email) as small
from raw_orders;

-- Remove dashes from phone numbers
 select 
           phone_number,
           replace(phone_number, '-' , '')
from raw_orders;

select * from raw_orders;
-- Combine  name + region into a single column like ‘John Doe - North’

--
-- Extract domain name from email
select 
	email,
    substring_index(email, '@', -1)
from raw_orders;
    
-- Replace NULL or blank names with 'Unknown'

select 
customer_name,
  coalesce(NULLIF(trim(customer_name), ''), 'Unknown') from raw_orders;
  
-- Validate email structure (contains ‘@’)

select
      email,
	case
        when email like '%@%' THEN 'Valid'
        else 'Invalid'
        end as validations
from raw_orders;
