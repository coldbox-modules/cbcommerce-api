<template>

	<b-row>
        <b-col md="6" class="my-1">
            <b-pagination 
                :total-rows="$parent.totalRows" 
                :per-page="$parent.perPage" 
                v-model="$parent.currentPage" 
                class="my-0" />
        </b-col>
    </b-row>

</template>