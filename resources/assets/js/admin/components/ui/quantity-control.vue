<template>

    <div :id="componentID" class="quantityControl">

        <label class="pull-left" v-if="showLabel">{{ label }}</label>

        <a
            @click="decreaseQty"
            class="qtyControl qtyMinus">
            <i class="fa fa-minus"></i>
        </a>

        <input
            ref="quantityInput"
            type="text"
            name="quantity"
            disabled="disabled"
            :value="quantity"
            class="qty" />

        <a
            @click="increaseQty"
            class="qtyControl qtyPlus">
            <i class="fa fa-plus"></i>
        </a>

    </div>

</template>

<script>
export default {
    components: {},
    props: {
        componentID: {
            default: 'quantityControlForm',
            type: String
        },
        sku: {
            type    : Object,
            required: false
        },
        quantity: {
            default: 1,
            type: Number
        },
        maxQuantity : {
            required : false,
            type : Number
        },
        showLabel: {
            default: true,
            type: Boolean
        },
        label: {
            default: 'Quantity',
            type: String
        }
    },
    data() {
        return {}
    },

    created: function(){
    },

    mounted() {},

    destroyed() {},

    methods: {

        getCurrentVal: function(){
            return parseInt( this.$refs.quantityInput.value );
        },

        setCurrentVal: function( quantity ){
            var self = this;
            if( !self.maxQuantity || quantity <= self.maxQuantity ){
                this.$refs.quantityInput.value = quantity;
                this.$emit(
                    'quantityChange',
                    {
                        quantity: quantity,
                        sku : self.sku
                    }
                );
            }
        },

        increaseQty: function(){
            const currentVal = this.getCurrentVal();
            const newVal = ( !isNaN( currentVal ) ) ? currentVal + 1 : 1;
            this.setCurrentVal( newVal );
        },

        decreaseQty: function(){
            const currentVal = this.getCurrentVal();
            const newVal = ( !isNaN( currentVal ) && currentVal > 1 ) ? currentVal - 1 : 1;
            this.setCurrentVal( newVal );
        }

    }

}
</script>