
-- =============================
-- CREATE TABLES
-- =============================

GOTO FRED

CREATE TABLE blpu
(
    record_identifier smallint,
    change_type  nvarchar(1),
    pro_order bigint,
    uprn bigint NOT NULL,
    logical_status smallint,
    blpu_state smallint,
    blpu_state_date date,
    parent_uprn bigint,
    x_coordinate double precision,
    y_coordinate double precision,
    latitude double precision,
    longitude double precision,
    rpc smallint,
    local_custodian_code smallint,
    country  nvarchar(1),
    start_date date,
    end_date date,
    last_update_date date,
    entry_date date,
    addressbase_postal  nvarchar(1),
    postcode_locator  nvarchar(8),
    multi_occ_count nvarchar(MAX),
    location_bng  nvarchar(MAX)
)


CREATE TABLE delivery_point
(
    record_identifier smallint,
    change_type  nvarchar(1),
    pro_order bigint,
    uprn bigint,
    udprn bigint,
    organisation_name nvarchar(60),
    department_name nvarchar(60),
    sub_building_name nvarchar(30),
    building_name nvarchar(80),
    building_number smallint,
    dependent_thoroughfare nvarchar(80),
    thoroughfare nvarchar(80),
    double_dependent_locality nvarchar(35),
    dependent_locality nvarchar(35),
    post_town nvarchar(30),
    postcode nvarchar(8),
    postcode_type nvarchar(1),
    delivery_point_suffix nvarchar(2),
    welsh_dependent_thoroughfare nvarchar(80),
    welsh_thoroughfare nvarchar(80),
    welsh_double_dependent_locality nvarchar(35),
    welsh_dependent_locality nvarchar(35),
    welsh_post_town nvarchar(30),
    po_box_number nvarchar(6),
    process_date date,
    start_date date,
    end_date date,
    last_update_date date,
    entry_date date
)

FRED:
-- =============================
-- BULK LOAD
-- =============================

-- Takes 19 minutes to do nothing
BULK
INSERT delivery_point
--FROM 'D:\Suzanne\AddressSearching\AddressBase\ID21_BLPU_Records.csv'
FROM 'D:\Suzanne\AddressSearching\test.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)

