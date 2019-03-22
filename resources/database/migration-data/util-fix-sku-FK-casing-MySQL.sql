ALTER TABLE `cbc_wishlistItems` 
DROP FOREIGN KEY `fk_cbc_wishlistItems_FK_sku`;

SELECT IF (
    EXISTS(
        SELECT * FROM INFORMATION_SCHEMA.STATISTICS  WHERE TABLE_NAME = 'cbc_wishlistItems'
        AND INDEX_NAME = 'fk_cbc_wishlistItems_FK_sku'
    )
    ,'DROP INDEX `fk_cbc_wishlistItems_FK_sku` ON `cbc_wishlistItems`'
    ,'select ''index fk_cbc_wishlistItems_FK_sku NOT FOUND'' _______;'
    ) INTO @a;
PREPARE stmt1 FROM @a;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

SELECT IF (
    EXISTS(
        SELECT * FROM INFORMATION_SCHEMA.STATISTICS  WHERE TABLE_NAME = 'cbc_wishlistItems'
        AND INDEX_NAME = 'fk_cbc_wishlistItems_FK_sku_idx'
    )
    ,'DROP INDEX `fk_cbc_wishlistItems_FK_sku_idx` ON `cbc_wishlistItems`'
    ,'select ''index fk_cbc_wishlistItems_FK_sku_idx NOT FOUND'' _______;'
    ) INTO @a;
PREPARE stmt2 FROM @a;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

ALTER TABLE `cbc_wishlistItems` 
ADD CONSTRAINT `fk_cbc_wishlistItems_FK_sku`
FOREIGN KEY (`FK_sku`)
REFERENCES `cbc_SKUs` (`id`)
ON DELETE CASCADE
ON UPDATE NO ACTION;

ALTER TABLE `cbc_wishlistItems`
ADD INDEX `fk_cbc_wishlistItems_FK_sku_idx` (`FK_sku` ASC);