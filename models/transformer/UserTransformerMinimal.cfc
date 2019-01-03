component extends="UserTransformer"{

    function transform( activeEntity ){
        var memento = super.transform( activeEntity );
        var removals = [
            "primaryPhone",
            "secondaryPhone",
            "email"
        ];
        
        removals.each( function( remove ){
            structDelete( memento, remove );
        } );

        return memento;
        
    }


}