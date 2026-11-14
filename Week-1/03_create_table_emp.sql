create
or replace table demo_db.mySchema.emp (
    first_name string,
    last_name string,
    email string,
    streetaddress string,
    city string,
    start_date date
);

INSERT INTO demo_db.mySchema.emp
VALUES
  ('Jane', 'Smith', 'jane.smith@example.com', '456 Oak Ave', 'Mumbai', '2026-02-01'),
  ('Raj', 'Patel', 'raj.patel@example.com', '789 Elm Rd', 'Delhi', '2026-03-10'); 