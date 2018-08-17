/**
 * @displayname CBC QuickEntity Interceptor
 * @description CBC Entity Interception methods
 * @author      Jon Clausen <jclausen@ortussolutions.com>
 **/
component {
    function quickPreSave( event, interceptData, buffer, rc, prc ){
        interceptData.entity.setModifiedTime( now() );
    }

    function quickPreInsert( event, interceptData, buffer, rc, prc ){
        interceptData.entity.setCreatedTime( now() );
    }
}