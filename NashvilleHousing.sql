select * from projectportfolio.NashvilleHousing;

# Standardize Date Format

select saledate,convert(Date,SaleDate) from projectportfolio.nashvillehousing;

#Populate Property Address Data

select * from projectportfolio.nashvillehousing
#where PropertyAddress is null;
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress) 
from projectportfolio.nashvillehousing a
JOIN projectportfolio.nashvillehousing b on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null;

Update a
SET property = isnull(a.PropertyAddress,b.PropertyAddress) 
from projectportfolio.nashvillehousing a
JOIN projectportfolio.nashvillehousing b on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null;

# Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From projectportfolio.nashvillehousing
#Where PropertyAddress is null
#order by ParcelID;

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From projectportfolio.nashvillehousing;

ALTER TABLE nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

Select * From projectportfolio.nashvillehousing;

Select OwnerAddress From projectportfolio.nashvillehousing;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From projectportfolio.nashvillehousing;

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

Select * From projectportfolio.nashvillehousing;

# Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From projectportfolio.nashvillehousing
Group by SoldAsVacant
order by 2;

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END Vacantfield
From projectportfolio.nashvillehousing;

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

# Remove Duplicates

WITH RowNumCTE AS(
Select *, ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) row_num
From projectportfolio.nashvillehousing
#order by ParcelID
)
Select * From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select * From projectportfolio.nashvillehousing;

# Delete Unused Columns

Select * From projectportfolio.nashvillehousing;

ALTER TABLE projectportfolio.nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;