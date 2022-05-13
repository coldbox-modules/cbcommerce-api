component extends="cbcommerce.handlers.api.v1.BaseAPIHandler"{
	property name="moduleSettings" inject="coldbox:moduleSettings:cbcommerce";

	function index( event, rc, prc ){
		prc.response.setData(
			moduleSettings.info
		);
    }

}
