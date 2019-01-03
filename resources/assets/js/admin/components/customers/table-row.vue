<template>

    <tr>
        <td>
            <router-link 
                :to="{ name: 'customerForm', params: { id: id } }">
                {{ fullName }}
            </router-link>
        </td>
        <td>{{ email }}</td>
        <td>{{ phone }}</td>
        <td>{{ zip }}</td>
        <td>{{ country }}</td>
        <td>{{ province }}</td>
        <td>{{ createdTime | dateToText }}</td>
        <td>
            <router-link 
                :to="{ name: 'customerForm', params: { id: id } }" 
                class="btn btn-success float-right">
                <i class="fa fa-pencil"></i>
            </router-link>
        </td>
    </tr>

</template>
<script>
import moment from "moment";
import { mapGetters, mapActions } from "vuex";
export default {

    props: [
        'customer'
    ],

    data() {
        return {
            id      : null,
            name    : null,
            email   : null,
            phone   : null,
            zip     : null,
            country : null,
            province: null,
            active  : null
        }
    },

    created() {
        this.parseContent();
    },

    computed: {

        fullName() {
            return this.firstName + " " + this.lastName;
        }

    },

    methods: {

        parseContent: function(){
            var self          = this;
            var parsedContent = self.customer;
            self.id           = parsedContent.id;
            self.firstName    = parsedContent.firstName;
            self.lastName     = parsedContent.lastName;
            self.email        = parsedContent.emailName;
            self.phone        = parsedContent.primaryPhone;
            self.zip          = parsedContent.billingAddresses[ 'resultsMap' ][ self.id ].postalCode;
            self.country      = parsedContent.billingAddresses[ 'resultsMap' ][ self.id ].country;
            self.province     = parsedContent.billingAddresses[ 'resultsMap' ][ self.id ].province;
            self.createdTime  = parsedContent.createdTime;
        }

    }

}
</script>