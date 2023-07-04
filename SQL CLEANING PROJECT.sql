--Cleaning data in SQL Queries

select * from [Portfolio Project].[dbo].[NashvilleHousing]

--I Standardize Date Format by first converting the date, altering the table and updating it. Formatted Date 
--I named it as SaleDateConverted1
select SaleDate, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
add SaleDateConverted1 Date;

Update NashvilleHousing
set SaleDateConverted1 = convert(Date,SaleDate)

select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing


--I Populate Property Address data

select PropertyAddress
from  [Portfolio Project].[dbo].[NashvilleHousing]
where PropertyAddress is null

--I Discover that there are no values(null) in some of the columns or samples

select * from PortfolioProject.dbo.NashvilleHousing
select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID

--I Discover that some ParcelID are the same which reflects their Property Address
--Therefore let populate the ParcelID without a Property Address with ParcelID that has a Property Address

--Using Join

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
set propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


--To clean the Address column, I Break out Address column into Individual Columns(Address, City, State)
--in other to do that we have to locate the comma

select PropertyAddress, ParcelID 
from [Portfolio Project].[dbo].[NashvilleHousing]
order by ParcelID
--Charindex is used to search for a word
select
SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) as Address,
 charindex(',',PropertyAddress)
from [Portfolio Project].[dbo].[NashvilleHousing]

--we do not want a comma at the end of the address
--therefore, to get rid of the comma, I input -1 

select
SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, charindex(',',PropertyAddress)+1 , Len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1, charindex(',',PropertyAddress)-1)

Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity =substring(PropertyAddress, charindex(',', PropertyAddress)+1 , Len(PropertyAddress))

select * from PortfolioProject.dbo.NashvilleHousing


--Breaking out address for the OwnerAddress column
--Using Parsename and Replace functions which is a lot easier than using Substring above
select OwnerAddress
from [Portfolio Project].[dbo].[NashvilleHousing]
select
Parsename(replace(OwnerAddress, ',','.'),3),
Parsename(replace(OwnerAddress, ',','.'),2),
Parsename(replace(OwnerAddress, ',','.'),1)
from [Portfolio Project].[dbo].[NashvilleHousing]

Alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);


Update NashvilleHousing
set OwnerSplitAddress = Parsename(replace(OwnerAddress, ',','.'),3)

Alter table NashvilleHousing
add OwnerSplitCity varchar(255);
Update NashvilleHousing
set OwnerSplitCity = Parsename(replace(OwnerAddress, ',','.'),2)

Alter table NashvilleHousing
add OwnerSplitState varchar(255);
Update NashvilleHousing
set OwnerSplitState = Parsename(replace(OwnerAddress, ',','.'),1)

select * from PortfolioProject.dbo.NashvilleHousing

--I decide to Change Y and N to Yes and No in "Sold as vacant" column

 select Distinct(SoldasVacant)
 from [Portfolio Project].[dbo].[NashvilleHousing]
 
 select Distinct(SoldasVacant), count(SoldasVacant)
 from [Portfolio Project].[dbo].[NashvilleHousing]
 group by SoldAsVacant
 order by 2

select SoldasVacant,
case when SoldasVacant = 'Y' then 'Yes'
     when SoldasVacant = 'N' then 'No'
	 else SoldasVacant
	 END
from [Portfolio Project].[dbo].[NashvilleHousing]

Update NashvilleHousing
set SoldasVacant = case when SoldasVacant = 'Y' then 'Yes'
     when SoldasVacant = 'N' then 'No'
	 else SoldasVacant
	 END
from [Portfolio Project].[dbo].[NashvilleHousing]

--I then proceed to remove duplicates
WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID, 
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    UniqueID 
					)row_num

from [Portfolio Project].[dbo].[NashvilleHousing]
order by ParcelID

--I decid to delete Unused Columns
select *
from [Portfolio Project].[dbo].[NashvilleHousing]


alter table [Portfolio Project].[dbo].[NashvilleHousing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress
--Then in the Acreage column,I convert the column to integer and update the table
select Acreage, convert(int, Acreage)
from [Portfolio Project].[dbo].[NashvilleHousing]

alter table [Portfolio Project].[dbo].[NashvilleHousing]
add Acreageconvert int

update [Portfolio Project].[dbo].[NashvilleHousing]
set Acreage = convert(int, Acreage)

select * from [Portfolio Project].[dbo].[NashvilleHousing]
