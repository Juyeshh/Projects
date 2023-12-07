SELECT *
  FROM Portfolio_Project.dbo.Sheet1


  --Standard Date Format
SELECT SaleDateConv, CONVERT(Date,SaleDate)
FROM Portfolio_Project.dbo.Sheet1

UPDATE Sheet1
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE Sheet1
ADD SaleDateConv DATE;

UPDATE Sheet1
SET SaleDateConv = CONVERT(DATE,SaleDate)


--Populate Property Address Data

SELECT *
FROM Portfolio_Project.dbo.Sheet1
--WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM Portfolio_Project.dbo.Sheet1 a
JOIN Portfolio_Project.dbo.Sheet1 b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project.dbo.Sheet1 a
JOIN Portfolio_Project.dbo.Sheet1 b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL




--------------------------------------------

--Breaking out Address into Individual Columns(Address, City, State)

SELECT PropertyAddress
FROM Portfolio_Project.dbo.Sheet1
--WHERE PropertyAddress is null
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))as Address

FROM Portfolio_Project.dbo.Sheet1



ALTER TABLE Sheet1
ADD PropertySplitAdd Nvarchar(255);

UPDATE Sheet1
SET PropertySplitAdd = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Sheet1
ADD PropertySplitCity Nvarchar(255);

UPDATE Sheet1
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
FROM Portfolio_Project.dbo.Sheet1




Select OwnerAddress
FROM Portfolio_Project.dbo.Sheet1






Select
PARSENAME(Replace(OwnerAddress,',', ','),3)
,PARSENAME(Replace(OwnerAddress,',', ','),2)
,PARSENAME(Replace(OwnerAddress,',', ','),1)
From Portfolio_Project.dbo.Sheet1 






ALTER TABLE Sheet1
ADD OwnerSplitAdd Nvarchar(255);

UPDATE Sheet1
SET OwnerSplitAdd = PARSENAME(Replace(OwnerAddress,',', ','),3)

ALTER TABLE Sheet1
Add OwnerSplitCity Nvarchar(255);

UPDATE Sheet1
SET PropertySplitCity = PARSENAME(Replace(OwnerAddress,',', ','),2)

ALTER TABLE Sheet1
ADD OwnerSplitState Nvarchar(255);

UPDATE Sheet1
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',', ','),1)
  

Select *
FROM Portfolio_Project.dbo.Sheet1


--Change Y and N to Yes and No in 'Sold as Vacant'field


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From Portfolio_Project.dbo.Sheet1
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'	
	   Else SoldAsVacant
	   End
From Portfolio_Project.dbo.Sheet1



Update Sheet1
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'	
	   Else SoldAsVacant
	   End




--Remove Duplicates


 With RowNumCTE As(
 Select *,
	ROW_NUMBER()Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					uniqueID
					) row_num
		 
 From Portfolio_Project.dbo.Sheet1
 --order by ParcelID
 )
 Select *
 From RowNumCTE
 Where row_num > 1
 Order by PropertyAddress


 --Delete Unused Columns

 Select *
 From Portfolio_Project.dbo.Sheet1

 Alter Table Portfolio_Project.dbo.Sheet1
 Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Portfolio_Project.dbo.Sheet1
Drop column SaleDate