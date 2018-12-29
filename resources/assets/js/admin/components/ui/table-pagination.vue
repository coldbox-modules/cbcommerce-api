<template>

	<b-row>
        <b-col md="6" class="my-1">
            <b-pagination 
                :total-rows="totalRows" 
                :per-page="perPage" 
                v-model="currentPage" 
                class="my-0" />
        </b-col>
    </b-row>

</template>
<script>
export default {

	props: {
		totalRows: {
			type    : Number,
			required: true,
			default : 0
		},
		perPage: {
			type    : Number,
			required: true,
			default : 5
		},
		currentPage: {
			type    : Number,
			required: true,
			default : 1
		}
	}

}
</script>