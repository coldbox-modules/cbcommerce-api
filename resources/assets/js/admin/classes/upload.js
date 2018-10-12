import axios from 'axios';

export default function ( url, file, name = 'avatar' ) {
  if( typeof url !== 'string' ){
    throw new TypeError( `Expected a string, got ${typeof url}` );
  }
  const formData = new FormData();
  formData.append( name, file );
  const config = {
    headers: {
      'content-type': 'multipart/form-data'
    }
  };
  return axios.post( url, formData, config );
};