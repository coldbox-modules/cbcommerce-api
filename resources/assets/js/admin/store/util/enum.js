/* JS has no "enum" type - that is, an enumerated type which
   can be any value from a fixed set of values.
   To simulate the error handling of an ENUM type,
   makeEnum takes an array of strings (as a set)
   and converts that to an object where each string is used
   as a key, set to it's own value. i.e.:
     enum = {
       value: "value"
       otherValue: "otherValue"
     }
   Referring to a non-existant key will throw an error, which we
   can then catch as an undefined value;
     enum.notValue === undefined // true;
   */

export const makeEnum = arr =>
  arr.reduce((pv, cv) => {
    pv[cv] = cv;
    return pv;
  }, {});

export default {
  makeEnum
};
