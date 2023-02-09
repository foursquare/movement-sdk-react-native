import { NativeModules } from 'react-native'

export const UserInfoUserIdKey = 'userId'
export const UserInfoGenderKey = 'gender'
export const UserInfoBirthdayKey = 'birthday'

export const UserInfoGenderMale = 'male'
export const UserInfoGenderFemale = 'female'
export const UserInfoGenderNotSpecified = 'not_specified'

const MovementSdk = NativeModules.RNMovementSdk
export default MovementSdk
