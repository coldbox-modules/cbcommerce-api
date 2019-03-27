<template>
    <div>
        <form @submit.prevent="handleSubmit">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="inputFirstName" class="control-label">Name:<span class="text-error">*</span></label>
                        <div>
                            <input
                                required="required"
                                type="text"
                                class="form-control"
                                id="inputName"
                                v-model="formData.name" />
                        </div>
                    </div>

                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="inputLastName" class="control-label">Email:<span class="text-error">*</span></label>
                        <div>
                            <input
                                required="required"
                                type="email"
                                class="form-control"
                                id="inputEmail"
                                v-model="formData.email" />
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="inputSubject" class="control-label">Phone:<span class="text-error">*</span></label>
                        <div>
                            <input
                                required="required"
                                type="text"
                                class="form-control"
                                id="inputPhone"
                                v-model="formData.phone" />
                        </div>
                    </div>
                </div>
                <div class="col-md-12 fm-hp">
                    <div class="form-group">
                        <label>Do not enter text in to the following field</label>
                        <input type="text" v-model="formData.hpInfo"/>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="inputText" class="control-label">Message:<span class="text-error">*</span></label>
                        <div>
                            <textarea
                                required="required"
                                class="form-control"
                                id="inputText"
                                :rows="messageHeight"
                                v-model="formData.message"></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="!isSending && isSent">
                <p class="alert alert-danger alert-dismissable" v-if="contactErrors.length">
                    There was an error sending your messages.  The reponse received was: {{ contactErrors.join( '. ' ) }}
                </p>
                <p v-else class="alert alert-success alert-dismissable">
                    Thank you, your message has been sent!
                </p>
            </div>
            <div class="clearfix"></div>
            <button type="submit" class="pull-right btn btn-secondary btn-lg">Send</button>
            <div class="clearfix"></div>
        </form>

        <div
            v-if="isSending && !isSent"
            class="progress-bar"
            role="progressbar"
            aria-valuenow="100"
            aria-valuemin="0"
            aria-valuemax="100"
            style="width: 100%">
            <span class="sr-only">Sending your message</span>
        </div>
    </div>
</template>
<script>
export default{

}
</script>