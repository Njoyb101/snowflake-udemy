-- Types of warehouses
-- XSMALL , 'X-SMALL'
-- SMALL
-- MEDIUM
-- LARGE
-- XLARGE , 'X-LARGE'
-- XXLARGE , X2LARGE , '2X-LARGE'
-- XXXLARGE , X3LARGE , '3X-LARGE'
-- X4LARGE , '4X-LARGE'

create or replace warehouse know_architecture_1 with
warehouse_size='X-SMALL'
auto_suspend = 180
auto_resume = true
initially_suspended=true;
