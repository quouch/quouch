export type QuouchIconsId =
  | "world"
  | "work"
  | "wifi"
  | "vegan"
  | "trip"
  | "star"
  | "star-full"
  | "star-empty"
  | "stack"
  | "smoking-allowed"
  | "sleep"
  | "shield"
  | "shared-room"
  | "send"
  | "profile-upload"
  | "private-room"
  | "privacy"
  | "plant"
  | "placeholder"
  | "pin"
  | "pin-dot"
  | "pets-allowed"
  | "people"
  | "notification"
  | "mission"
  | "message"
  | "map-pin"
  | "logout"
  | "invite"
  | "info-circle"
  | "impressum"
  | "home"
  | "hangout"
  | "guidelines"
  | "follow"
  | "faq"
  | "face-laugh"
  | "face-laugh-beam"
  | "extra-key"
  | "euro"
  | "error"
  | "elevator"
  | "edit-profile"
  | "couch"
  | "copy"
  | "contact"
  | "conditions"
  | "close"
  | "cities"
  | "check-box"
  | "chat"
  | "calendar"
  | "bed"
  | "barrier-free"
  | "balcony"
  | "account";

export type QuouchIconsKey =
  | "World"
  | "Work"
  | "Wifi"
  | "Vegan"
  | "Trip"
  | "Star"
  | "StarFull"
  | "StarEmpty"
  | "Stack"
  | "SmokingAllowed"
  | "Sleep"
  | "Shield"
  | "SharedRoom"
  | "Send"
  | "ProfileUpload"
  | "PrivateRoom"
  | "Privacy"
  | "Plant"
  | "Placeholder"
  | "Pin"
  | "PinDot"
  | "PetsAllowed"
  | "People"
  | "Notification"
  | "Mission"
  | "Message"
  | "MapPin"
  | "Logout"
  | "Invite"
  | "InfoCircle"
  | "Impressum"
  | "Home"
  | "Hangout"
  | "Guidelines"
  | "Follow"
  | "Faq"
  | "FaceLaugh"
  | "FaceLaughBeam"
  | "ExtraKey"
  | "Euro"
  | "Error"
  | "Elevator"
  | "EditProfile"
  | "Couch"
  | "Copy"
  | "Contact"
  | "Conditions"
  | "Close"
  | "Cities"
  | "CheckBox"
  | "Chat"
  | "Calendar"
  | "Bed"
  | "BarrierFree"
  | "Balcony"
  | "Account";

export enum QuouchIcons {
  World = "world",
  Work = "work",
  Wifi = "wifi",
  Vegan = "vegan",
  Trip = "trip",
  Star = "star",
  StarFull = "star-full",
  StarEmpty = "star-empty",
  Stack = "stack",
  SmokingAllowed = "smoking-allowed",
  Sleep = "sleep",
  Shield = "shield",
  SharedRoom = "shared-room",
  Send = "send",
  ProfileUpload = "profile-upload",
  PrivateRoom = "private-room",
  Privacy = "privacy",
  Plant = "plant",
  Placeholder = "placeholder",
  Pin = "pin",
  PinDot = "pin-dot",
  PetsAllowed = "pets-allowed",
  People = "people",
  Notification = "notification",
  Mission = "mission",
  Message = "message",
  MapPin = "map-pin",
  Logout = "logout",
  Invite = "invite",
  InfoCircle = "info-circle",
  Impressum = "impressum",
  Home = "home",
  Hangout = "hangout",
  Guidelines = "guidelines",
  Follow = "follow",
  Faq = "faq",
  FaceLaugh = "face-laugh",
  FaceLaughBeam = "face-laugh-beam",
  ExtraKey = "extra-key",
  Euro = "euro",
  Error = "error",
  Elevator = "elevator",
  EditProfile = "edit-profile",
  Couch = "couch",
  Copy = "copy",
  Contact = "contact",
  Conditions = "conditions",
  Close = "close",
  Cities = "cities",
  CheckBox = "check-box",
  Chat = "chat",
  Calendar = "calendar",
  Bed = "bed",
  BarrierFree = "barrier-free",
  Balcony = "balcony",
  Account = "account",
}

export const QUOUCH_ICONS_CODEPOINTS: { [key in QuouchIcons]: string } = {
  [QuouchIcons.World]: "61697",
  [QuouchIcons.Work]: "61698",
  [QuouchIcons.Wifi]: "61699",
  [QuouchIcons.Vegan]: "61700",
  [QuouchIcons.Trip]: "61701",
  [QuouchIcons.Star]: "61702",
  [QuouchIcons.StarFull]: "61703",
  [QuouchIcons.StarEmpty]: "61704",
  [QuouchIcons.Stack]: "61705",
  [QuouchIcons.SmokingAllowed]: "61706",
  [QuouchIcons.Sleep]: "61707",
  [QuouchIcons.Shield]: "61708",
  [QuouchIcons.SharedRoom]: "61709",
  [QuouchIcons.Send]: "61710",
  [QuouchIcons.ProfileUpload]: "61711",
  [QuouchIcons.PrivateRoom]: "61712",
  [QuouchIcons.Privacy]: "61713",
  [QuouchIcons.Plant]: "61714",
  [QuouchIcons.Placeholder]: "61715",
  [QuouchIcons.Pin]: "61716",
  [QuouchIcons.PinDot]: "61717",
  [QuouchIcons.PetsAllowed]: "61718",
  [QuouchIcons.People]: "61719",
  [QuouchIcons.Notification]: "61720",
  [QuouchIcons.Mission]: "61721",
  [QuouchIcons.Message]: "61722",
  [QuouchIcons.MapPin]: "61723",
  [QuouchIcons.Logout]: "61724",
  [QuouchIcons.Invite]: "61725",
  [QuouchIcons.InfoCircle]: "61726",
  [QuouchIcons.Impressum]: "61727",
  [QuouchIcons.Home]: "61728",
  [QuouchIcons.Hangout]: "61729",
  [QuouchIcons.Guidelines]: "61730",
  [QuouchIcons.Follow]: "61731",
  [QuouchIcons.Faq]: "61732",
  [QuouchIcons.FaceLaugh]: "61733",
  [QuouchIcons.FaceLaughBeam]: "61734",
  [QuouchIcons.ExtraKey]: "61735",
  [QuouchIcons.Euro]: "61736",
  [QuouchIcons.Error]: "61737",
  [QuouchIcons.Elevator]: "61738",
  [QuouchIcons.EditProfile]: "61739",
  [QuouchIcons.Couch]: "61740",
  [QuouchIcons.Copy]: "61741",
  [QuouchIcons.Contact]: "61742",
  [QuouchIcons.Conditions]: "61743",
  [QuouchIcons.Close]: "61744",
  [QuouchIcons.Cities]: "61745",
  [QuouchIcons.CheckBox]: "61746",
  [QuouchIcons.Chat]: "61747",
  [QuouchIcons.Calendar]: "61748",
  [QuouchIcons.Bed]: "61749",
  [QuouchIcons.BarrierFree]: "61750",
  [QuouchIcons.Balcony]: "61751",
  [QuouchIcons.Account]: "61752",
};
