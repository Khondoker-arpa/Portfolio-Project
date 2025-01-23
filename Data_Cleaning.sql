/*

Cleaning Data in SQL Queries

*/


select * from NashvilleHousing ;



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate,CONVERT(date,SaleDate)
from NashvilleHousing;

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate);



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueId<>b.UniqueId
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueId<>b.UniqueId
where a.PropertyAddress is null;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress from NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
from NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

select * from NashvilleHousing

select OwnerAddress
from NashvilleHousing


select
PARSENAME(replace(OwnerAddress,',','.'),1) as state,
PARSENAME(replace(OwnerAddress,',','.'),2) as city,
PARSENAME(replace(OwnerAddress,',','.'),3) as Address
from NashvilleHousing

alter table NashvilleHousing
add State nvarchar(255)

update NashvilleHousing
set State = PARSENAME(replace(OwnerAddress,',','.'),1) 

select * from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct SoldAsVacant
from NashvilleHousing

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH cte 
AS(
select *,
ROW_NUMBER() 
over(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference 
order by UniqueID) as row_num
from NashvilleHousing

) 
/*delete from cte
where row_num > 1*/


select * from cte
where row_num > 1



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * from NashvilleHousing


alter table NashvilleHousing
drop column PropertyAddress,OwnerAddress,TaxDistrict

















