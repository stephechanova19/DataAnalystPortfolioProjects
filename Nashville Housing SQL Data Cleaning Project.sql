
/*

Cleaning Data in SQL Queries

*/



Select SaleDateConverted, CONVERT(Date, SaleDate)
From Portfolio.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------
----------------------- Standardize Date Format ------------------------------------------ 

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select *
From Portfolio.dbo.NashvilleHousing

------------------------------------------------------------------------------------
-------------------- Populate Property Address Data -------------------------------
 
SELECT *
From Portfolio.dbo.NashvilleHousing

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID =	b.ParcelID	
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID =	b.ParcelID	
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

SELECT PropertyAddress
From Portfolio.dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into invidual columns (Address, City, State)

SELECT PropertyAddress
From Portfolio.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City

From Portfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
From Portfolio.dbo.NashvilleHousing

Select OwnerAddress
From Portfolio.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
From Portfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = 

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)


--- Change Y and N to Yes and No in "Sold as Vacant" field ---- 

Select SoldAsVacant
From Portfolio.dbo.NashvilleHousing

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

Select SoldAsVacant,
	 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
	 END
From Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
	 END

---- Remove Duplicates --

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio.dbo.NashvilleHousing
)
SELECT *
From RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

Select *
From RowNumCTE

--- DELETE UNUSED COLUMNS ----

SELECT *
FROM Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, 

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate
