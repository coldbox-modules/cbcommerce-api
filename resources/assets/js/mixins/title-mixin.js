function getTitle( vm ) {
    const { title } = vm.$options
    if (title) {
        return typeof title === 'function'
        ? title.call( vm )
        : title
    }
}

export default {
    computed : {
        title(){ 
            return getTitle( this );
        }
    },
    mounted() {
        if( this.title ){
            document.title = this.title;
        }
    },
    watch : {
        title : function( newTitle, oldTitle ){
            if( newTitle &&  ( newTitle !== oldTitle ) ){
                document.title = newTitle
            }
        }
    }
}