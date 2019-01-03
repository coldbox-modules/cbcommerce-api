<template>

    <tr>
        <td>
            <router-link 
                :to="{ name: 'categoryForm', params: { id: category.id } }">
                {{category.name}}
            </router-link>
        </td>
        <td>{{ category.isActive | itemStatusToText }}</td>
        <td>
            <router-link 
                :to="{ name: 'categoryForm', params: { id: category.id } }" 
                class="btn btn-success float-right">
                <i class="fa fa-pencil"></i>
            </router-link>
        </td>
    </tr>

</template>
<script>
export default {

    props: [
        'category'
    ]

}
</script>