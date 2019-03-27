<template>
    <div>
        <div class="header-for-light">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">
                {{ wishlist.id ? 'Editing ' + wishlist.name : 'Create New' }}
            </h1>
        </div>
        <wishlist-form :wishlist="wishlist"></wishlist-form>
    </div>
</template>
<script>
export default {
    props : {
        wishlist : {
            type : Object,
            default : {
                name : "",
                description : "",
                isDefault : false
            }
        }
    },
    computed : {
        wishlistId : () => {
            var locationParts = window.location.pathname.split( '/' );
            return locationParts[ locationParts.length - 1 ];
        }
    }
}
</script>