<template>

	<div>
		<span 
			v-show="!showField()" 
			@click="focusField()">{{ thisValue | currency }}</span>
		<b-input-group v-show="showField()">
			<b-form-input 
				type="number"
				:min="minimumValue"
				ref="inputField"
				v-model="thisValue" 
				@focus="focusField"
				@keydown.enter.native="onValueChange">
			</b-form-input>
		</b-input-group>
	</div>

</template>
<script>
export default {

	props: {
		minimumValue: {
			type   : Number,
			default: 0
		},
		fieldValue: {
			type    : Number,
			required: true
		},
		parentId: {
			type    : String,
			required: false,
			default : ""
		}
	},

	data() {
		return {
			thisValue: null,
			editField: false
		}
	},

	created() {
		this.thisValue = this.fieldValue;
	},

	methods: {

		onValueChange( event ) {
			event.preventDefault();
			this.editField = false;
			var self = this;
            Event.$emit( 'valueChange', {
				fieldValue: self.thisValue,
				parentId  : self.parentId
            } );
		},

		focusField() {
			this.editField = true;
			this.$refs.inputField.$el.focus();
		},

		showField(){
			return ( this.editField == true ) ? true : false;
		},

	}

}
</script>