
select *
from [Portfolio-Project]..NashvillHousingData

select PropertyAddress
from [Portfolio-Project]..NashvillHousingData

----------------------------------------------------------------------------------------
--Standardize Sales Format

select SaleDate, CONVERT(Date, SaleDate)
from [Portfolio-Project]..NashvillHousingData

alter table NashvillHousingData
add SaleDateConverted Date

update NashvillHousingData
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted, CONVERT(Date, SaleDate)
from [Portfolio-Project]..NashvillHousingData

----------------------------------------------------------------------------------------
--Populate Property Address Data

select PropertyAddress
from [Portfolio-Project]..NashvillHousingData
where PropertyAddress is null

select *
from [Portfolio-Project]..NashvillHousingData
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from [Portfolio-Project]..NashvillHousingData a
join [Portfolio-Project]..NashvillHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--populate
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress) as PopulatedPropertyAddress
from [Portfolio-Project]..NashvillHousingData a
join [Portfolio-Project]..NashvillHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--updated table a (NashvillHouseingData)
update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio-Project]..NashvillHousingData a
join [Portfolio-Project]..NashvillHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------
--break out PropertyAddress into individual columns (Address, City, State)

select 
SUBSTRING(PropertyAddress,1 , CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
from [Portfolio-Project]..NashvillHousingData

--better way of spliting address is using (PARSNAME)
--select 
--PARSENAME(replace(PropertyAddress,',','.'),2) as Address,
--PARSENAME(replace(PropertyAddress,',','.'),1) as City
--from [Portfolio-Project]..NashvillHousingData

alter table [Portfolio-Project]..NashvillHousingData
add PropertySplitAddress nvarchar(255)

update [Portfolio-Project]..NashvillHousingData
set PropertySplitAddress = SUBSTRING(PropertyAddress,1 , CHARINDEX(',',PropertyAddress)-1)

alter table [Portfolio-Project]..NashvillHousingData
add PropertySplitCity nvarchar(255)

update [Portfolio-Project]..NashvillHousingData
set PropertySplitCity = SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select *
from [Portfolio-Project]..NashvillHousingData

----------------------------------------------------------------------------------------
--Breaking out OwnerAdress into three individual Adress ( city, state, address)
--Using Parsname
select OwnerAddress
from [Portfolio-Project]..NashvillHousingData

select 
PARSENAME(replace(OwnerAddress,',','.'),3) as Address,
PARSENAME(replace(OwnerAddress,',','.'),2) as City,
PARSENAME(replace(OwnerAddress,',','.'),1) as State
from [Portfolio-Project]..NashvillHousingData

alter table [Portfolio-Project]..NashvillHousingData
add OwnerSplitAddress nvarchar(255)

update [Portfolio-Project]..NashvillHousingData
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table [Portfolio-Project]..NashvillHousingData
add OwnerSplitCity nvarchar(255)

update [Portfolio-Project]..NashvillHousingData
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

alter table [Portfolio-Project]..NashvillHousingData
add OwnerSplitState nvarchar(255)

update [Portfolio-Project]..NashvillHousingData
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from [Portfolio-Project]..NashvillHousingData

----------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "SoldAsVacant" Field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Portfolio-Project]..NashvillHousingData
group by SoldAsVacant
order by 2

--using CASE statement for chaning the character

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [Portfolio-Project]..NashvillHousingData

--update the table
update [Portfolio-Project]..NashvillHousingData
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

----------------------------------------------------------------------------------------
--Remove Duplicate

select *
from [Portfolio-Project]..NashvillHousingData

--using CTE
with RowNumCTE as (
select *,
ROW_NUMBER() over (
partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
				order by 
				UniqueID) row_num
from [Portfolio-Project]..NashvillHousingData
)

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


--deleting duplicate rows
with RowNumCTE as (
select *,
ROW_NUMBER() over (
partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
				order by 
				UniqueID) row_num
from [Portfolio-Project]..NashvillHousingData
)

delete
from RowNumCTE
where row_num > 1

----------------------------------------------------------------------------------------
--Delete Unused Columns

select *
from [Portfolio-Project]..NashvillHousingData

alter table [Portfolio-Project]..NashvillHousingData
drop column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict