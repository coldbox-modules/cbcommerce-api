<template>

    <b-container class="mt-2 sidebar-panel">

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
                                :src="form.src" 
                                :alt="form.originalFileName"
                                :title="form.originalFileName"
                                fluid />
                            </div>

                        </b-col>

                        <b-col cols="6">

                            <b-form-group
                                label="Link"
                                label-for="imageHREF">
                                <a :href="form.src">{{form.src}}</a>
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

                            <b-form-group label="Enable the image">
                                <b-form-radio-group
                                    v-model="form.isActive"
                                    :options="booleanOptions"
                                    name="isActive"
                                ></b-form-radio-group>
                            </b-form-group>

                            <b-form-group label="Set as the primary image">
                                <b-form-radio-group
                                    v-model="form.isPrimary"
                                    :options="booleanOptions"
                                    name="isPrimary"
                                ></b-form-radio-group>
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
import { mapActions } from 'vuex';
export default {

    props: {
        data: {
            type    : Object,
            required: true
        },
        saveCallback: {
            type : Function,
            required : false
        },
        eventPrefix : {
            type : String,
            default : ""
        }
    },

    data() {
        return {
            form: new Form( this.data.image ),
            booleanOptions : [
                { text: 'Yes', value: true },
                { text: 'No', value: false }
            ]
        };
    },

    methods: {

        closePanel() {
            this.$emit( "closePanel", {} );
        },
        saveImageDetails() {
            Event.$emit( this.eventPrefix + 'saveImageDetails', this.form );
            Object.assign( this.data.image, this.form );
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