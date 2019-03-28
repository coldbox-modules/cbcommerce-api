import { mapState, mapMutations } from "vuex";
export default {
    data(){
        return {
            showQuoteModal : false
        }
    },
    computed : {
        ...mapState({
            quotedSKUId : state => state.products.quotedSKUId
        })
    },
    methods : {
        ...mapMutations([ "setQuotedSKUId" ]),
        showSkuQuoteForm( skuId ){
            this.setQuotedSKUId( skuId );
            Vue.set( this, "showQuoteModal", true );
        },
        toggleModal(){
            Vue.set( this, "showQuoteModal", !this.showModal );
            if( !this.showModal ){
                this.setQuotedSKUId( null );
            }
        }
    }
}