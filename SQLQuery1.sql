/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Cleaning1].[dbo].[NashvilleHousing]

  -- Cleaning Data in SQL Queries
  SELECT *
   FROM Cleaning1.dbo.NashvilleHousing;

   -- Standardize Date Format
   SELECT SaleDateConverted, CONVERT(Date, SaleDate)
   FROM Cleaning1.dbo.NashvilleHousing;

   Update NashvilleHousing
   SET SaleDate = CONVERT(Date, SaleDate)

   ALTER TABLE NashvilleHousing
   Add SaleDateConverted Date

   Update NashvilleHousing
   SET SaleDateConverted = CONVERT(Date, SaleDate)

   -- Populate Property Address Data
   Select *
	FROM Cleaning1.dbo.NashvilleHousing
	--Where PropertyAddress is NULL
	order by ParcelID

	Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM Cleaning1.dbo.NashvilleHousing a
	JOIN Cleaning1.dbo.NashvilleHousing b
		on a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

	Update a
	SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM Cleaning1.dbo.NashvilleHousing a
	JOIN Cleaning1.dbo.NashvilleHousing b
		on a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null

	-- Breaking out Address into Individual Columns (Address, City, State)

	Select PropertyAddress
	FROM Cleaning1.dbo.NashvilleHousing
	-- Where PropertyAddress is null
	-- order by ParcelID


	SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
	FROM Cleaning1.dbo.NashvilleHousing 

 ALTER TABLE NashvilleHousing
   Add PropertySplitAddress Nvarchar(255);

   Update NashvilleHousing
   SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

 ALTER TABLE NashvilleHousing
   Add PropertySplitCity Nvarchar(255);

   Update NashvilleHousing
   SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

   Select * 
   From Cleaning1.dbo.NashvilleHousing;

   Select OwnerAddress
   From Cleaning1.dbo.NashvilleHousing

   Select
   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
   From Cleaning1.dbo.NashvilleHousing


   ALTER TABLE NashvilleHousing
   Add OwnerSplitAddress Nvarchar(255);

   Update NashvilleHousing
   SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

 ALTER TABLE NashvilleHousing
   Add OwnerSplitCity Nvarchar(255);

   Update NashvilleHousing
   SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

   ALTER TABLE NashvilleHousing
   Add OwnerSplitState Nvarchar(255);

   Update NashvilleHousing
   SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

   Select * 
   From Cleaning1.dbo.NashvilleHousing;

   -- Change Y and N to Yes and No in "Sold as Vacant" field.

   Select Distinct(SoldAsVacant), Count(SoldAsVacant)
   From Cleaning1.dbo.NashvilleHousing
   Group by SoldAsVacant
   order by 2

   Select SoldAsVacant,
   CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
	From Cleaning1.dbo.NashvilleHousing

	Update NashvilleHousing
	SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END

	-- Remove Duplicates

WITH RowNumCTE AS(
	Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						) row_num

	From Cleaning1.dbo.NashvilleHousing
	--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Delete
-- From RowNumCTE
-- Where row_num > 1


	Select *
	From Cleaning1.dbo.NashvilleHousing

	-- Delete Unused Columns

	Select *
	From Cleaning1.dbo.NashvilleHousing

	ALTER TABLE Cleaning1.dbo.NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	ALTER TABLE Cleaning1.dbo.NashvilleHousing
	DROP COLUMN SaleDate
