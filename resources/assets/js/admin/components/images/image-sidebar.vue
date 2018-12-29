<template>

	<b-container class="mt-2">

		<b-row>

			<b-col cols="11" class="mt-2">
    
			    <h2>Image Detail</h2>
			    
			</b-col>

			<b-col cols="1" class="mt-2">
				<span class="pull-right">
					<i 
						class="fa fa-close closePanelIcon" 
						@click="closePanel()"></i>
				</span>
			</b-col>
		    
		    <b-col class="mt-3">

				<b-card class="mb-1">

			    	<b-row>

			    		<b-col cols="6">

			    			<div class="card-image">
						      <b-img 
						        :src="form.variations.thumbnail" 
						        :alt="form.title"
						        :title="form.title"
						        fluid />
						    </div>

			    		</b-col>

			    		<b-col cols="6">
			    
							<b-form-group
								label="Title"
								label-for="imageTitle">
								<b-form-input id="imageTitle" v-model.trim="form.title"></b-form-input>
							</b-form-group>

							<b-form-group
								label="Caption"
								label-for="imageCaption">
								<b-form-textarea
									id="imageCaption"
									v-model="form.caption"
									:rows="3"
									:max-rows="6">
								</b-form-textarea>
							</b-form-group>

							<b-form-group
								label="Link To"
								label-for="imageHREF">
								<b-form-input id="imageHREF" v-model.trim="form.href"></b-form-input>
							</b-form-group>

							<b-form-group>

								<b-form-checkbox id="imageIsActive"
									v-model="form.isActive"
									value="true"
									unchecked-value="false">
									Enable the image
								</b-form-checkbox>

							</b-form-group>

							<b-form-group>

								<b-form-checkbox id="imageIsPrimary"
									v-model="form.isPrimary"
									value="true"
									unchecked-value="false">
									Set as the primary image
								</b-form-checkbox>								

							</b-form-group>

							<button 
								id="saveImageDetails"
								class="btn btn-success" 
								@click="saveImageDetails">
								Save Details
							</button>

					    </b-col>

					</b-row>

				</b-card>

			</b-col>

		</b-row>
    
    </b-container>

</template>

<script>
import { Form } from '@cbCommerce/admin/classes/form';
export default {

	props: {
		data: {
			type    : Object,
			required: true
		}
	},

	data() {
		return {
			form: new Form(),
		};
	},

	methods: {

		closePanel() {
			this.$emit( 'closePanel', {
				imageDetails: this.form
			} );
		},

		saveImageDetails() {
			console.log( 'nothing happening here yet' );
			this.closePanel();
		}

	},

	created() {
		Object.assign( this.form, this.data.image || {} );
	}

}
</script>
<style>
i.closePanelIcon { 
	cursor: pointer;
	font-size: 24px;
}
</style>