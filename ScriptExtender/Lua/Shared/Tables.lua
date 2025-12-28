Globals = Globals or {}

AllParameterTypes = {
    'ScalarParameters',
    'Vector3Parameters',
    'VectorParameters',
    'Texture2DParameters',
    'VirtualTextureParameters'
}

AllAttachments = {
    'Hair',
    'Head',
    'NakedBody',
    'Private Parts',
    'Tail',
    'Horns',
    'Piercing',
    'Wings',
    'DragonbornChin',
    'DragonbornJaw',
    'DragonbornTop'
}

CCSkinUuids = {
    'bc372dfb-3a0a-4fc4-a23d-068a12699d78',
    'e3cee464-637e-4a20-ab90-1a90c6d06a43',
    'a0561348-f2f5-447b-9dd0-a2d80b79c892',
    '6ad28264-d419-4fbb-a514-062386f8d923',
    'e542c845-b1e0-4349-9f5e-649d0da52c0e',
    '7beb0d54-9ee7-44fd-adec-c96dc989bb42',
    '68e23b81-d09b-4c63-ad3c-08958d329a68',
    '685eb026-02d2-41f4-9de9-b2dd51de40e5',
    'c5bce236-33db-4662-b9e0-89d20c16c933',
    'c19c608e-f8d3-45a4-9bb6-a6548ac1e8e3',
    'dffbbc9f-8877-4af6-a1f6-095f3b41214c',
    'dcb67f1d-359a-4fc4-bc14-b588cb50aa08',
    '9e9a513c-bc63-4374-a835-169f269c4dfc',
    'a0741c4c-2e20-4ab4-876e-f23769b5c7a8',
    '398b523a-632f-4b74-97f7-9217f83d7d28',
    'f7b1d2a1-942d-477c-b3b8-bb5fa827a94f',
    'fb4c729b-41df-49de-86df-72de6d34a45d',
    '4d2aa967-5c18-47ac-8d0b-dc5f151acfb0',
    'e3c9c5b9-ce5a-4ffd-8944-79b348a22366',
    '0f91955f-28ef-4c99-a22a-b9c2f67f3ad1',
    '73d8cbd9-27fd-4991-972c-1977a995f69a',
    'a08fcb9d-5aa7-465c-ab49-d5b986541e95',
    '3dafa009-ccf3-458f-bd7b-edfd9c1e13db',
    '8318ba69-21c0-44a7-a0ce-29b4f67bc0c5',
    '74f27f58-c75f-4d1c-ba24-cd6048812ce8',
    '18e9fee7-649a-4af7-8974-ad431904842f',
    '97cb8647-c150-4c4f-ad01-b46d87f3f601',
    '97d8ceee-eacc-4057-9028-a112fd9d35b4',
    '398061cf-da56-45bc-909d-e42a3a6b8821',
    'e9ebc83f-d7f5-459f-8aff-b0d200e5ff49',
    'f400e525-718b-4d02-97ba-6702029f458b',
    '5617af94-c374-4231-bf63-ec2d3bcd5e86',
    '52b42c60-dd58-405e-a73f-afe5fa07ae74',
    '598ccc29-2c27-4a64-aa5e-2a36d60f992b',
    '09170204-4976-473c-89bc-393efe7859ae',
    '190da457-8b3b-4dd5-9e5d-23ac3424d581',
    '39dc6983-8d92-4b52-9f88-9fb9e43f85e6',
    '8d76f43f-82c9-4b10-acc5-18a13a54cd64',
    '98c63cda-62a0-4852-b459-75196dd4e654',
    'b5c0a60f-59ca-4640-b06b-538d48f12a4f',
    '94f8315c-452a-4310-a49c-e0767b03a552',
    'a91d04c8-0987-4318-bcf9-e33bf796793a'
}

CCHairUuids = {
    '6bfe8eb0-6c80-4edd-9ff4-0ff8f70f1ec1',
    '5b671c83-4ae4-4aed-874b-1977d353bdd1',
    'c6b09316-5ccb-4185-918d-d8e42cf95b4e',
    '637a1f7b-b7a3-4e3d-9195-8668a247beff',
    'f14efec5-31a8-4198-9189-a385fa1d0199',
    '0a256177-e68b-40a3-a314-6edb81577125',
    '5c1a35cb-8f35-41de-b86b-e0c666c85145',
    'd27955c3-37f7-4ac5-8776-542d8487ad1d',
    'c1545db0-4d1f-41ce-a8d3-9fd5ab9691ff',
    'f89219bc-b72d-4a62-a9e8-fb35706b147b',
    '0c9855a6-0763-40d6-93ee-64575f306859',
    '2b02ac7c-70d3-410f-a2a2-8db4b50b4af4',
    '9983c457-a125-4811-92bc-b971f6d47fc3',
    '7d1cb152-aa14-4bc5-8cbf-a9a88c3cdb55',
    'c5812f86-b035-4e8a-a632-2ec06f75aa54',
    '38f7706a-83cc-4083-b1ee-98ef1829b4aa',
    'f325d1aa-cc36-470d-88ed-b11334598543',
    '5a5eb3a5-3ee2-4da3-a5fe-d394210d20ec',
    '7d1cd855-e014-4922-a769-920f8f220260',
    'd6649330-3e86-4d98-b5c2-8a429a2a9907',
    'cec8d078-3dbb-4b62-97d7-c736ffd4f3fc',
    '366cf93b-d45a-470e-907c-08e95833a11c',
    '59007893-169b-4a9f-a62c-8c5452451481',
    '9ab03813-24fd-4dc1-b5fb-711e740e026e',
    'dc6fc2cc-a1b0-494a-bee0-ccf323b4b81d',
    'f4c7e4a5-dd8f-4ce5-856c-98d283a79b7a',
    '98e1c0ed-5b53-4cb2-8e3c-26874d04a515',
    '9c838bbf-22b3-450f-8082-4ab75f1e86db',
    '617efee4-369b-422f-bdfb-2a4ab7cebb5d',
    'deeca240-fd09-45cc-b058-001fdf26ac69',
    '8a0f75be-eb16-48a0-8fa1-5eceb625b4b7',
    'd30bb24b-bf16-4907-aba1-36798284ea6a',
    '80ffc3e6-2d0f-48c6-8a5b-a34dc6a076e1',
    '3bbf74a3-95fb-4c89-b805-67f3c56b5665',
    '82c28c5c-0503-4bf3-8247-ecb350810bb9',
    '30dedf4c-0b52-446c-8910-9c3d8660ce50',
    '3d09dc8c-5345-437b-bc60-265334c708c9',
    '82da92a2-29a7-4bf4-abea-40dbee77bd51',
    'c809f626-5d51-4252-a4d9-5efae3205b1e',
    '49169963-65fd-4fdf-801d-349cfd25fb94'
}


CCTattooUuids = {
    '7de88341-07bb-4852-8c06-27ffcfdba7ba',
}

CCMakeUpUuids = {
    '42f533ab-52f1-2531-72e7-0c2bcff79eaf',
}

CCdummies = {
    "e2badbf0-159a-4ef5-9e73-7bbeb3d1015a", --S_GLO_CharacterCreationDummy_001
    "aa772968-b5e0-4441-8d86-2d0506b4aab5", --S_GLO_CharacterCreationDummy_002
    "81c48711-d7cc-4a3d-9e49-665eb915c15c", --S_GLO_CharacterCreationDummy_003
    "6bff5419-5a9e-4839-acd4-cac4f6e41bd7", --S_GLO_CharacterCreationDummy_004
}

-- repeated_params = {
--     Scalar = {
--         IsTav = {"Body", "Genital", "Head"},
--         InvertOpacity = {"Body", "Genital", "Head"},
--         AnimationSpeed = {"Body", "Genital", "Head"},
--         GlowMultiplier = {"Body", "Genital", "Head"},
--         DetailNormalTiling = {"Body", "Genital"},
--         HemoglobinAmount = {"Body", "Genital", "Head"},
--         VeinAmount = {"Body", "Genital", "Head"},
--         MelaninDarkThreshold = {"Body", "Genital", "Head"},
--         MelaninDarkMultiplier = {"Body", "Genital", "Head"},
--         MelaninAmount = {"Body", "Genital", "Head"},
--         YellowingAmount = {"Body", "Genital", "Head"},
--         doDrawTattoo = {"Body", "Genital", "Head"},
--         BodyTattooIndex = {"Body", "Genital"},
--         TattooCurvatureInfluence = {"Body", "Genital", "Head"},
--         AdditionalTattooIntensity = {"Body", "Head"},
--         Dirt_Wetness = {"Body", "Genital", "Hair", "Head"},
--         Blood_Sharpness = {"Body", "Genital", "Head"},
--         Dirt_Sharpness = {"Body", "Genital", "Head"},
--         TMP_BODY_ROUGH = {"Body", "Genital"},
--         TattooRoughnessOffset = {"Body", "Genital", "Head"},
--         Dirt = {"Body", "Genital", "Hair", "Head"},
--         Blood = {"Body", "Genital", "Hair", "Head"},
--         Sweat = {"Body", "Head"},
--         Bruises = {"Body", "Head"},
--         Freckles = {"Body", "Head"},
--         FrecklesWeight = {"Body", "Head"},
--         Vitiligo = {"Body", "Head"},
--         VitiligoWeight = {"Body", "Head"},
--         MelaninRemovalAmount = {"Body", "Head"},
--         NonSkin_Weight = {"Body", "Head"},
--         Grime = {"Body", "Head"},
--         TattooMetalness = {"Body", "Head"},
--         MakeupIntensity = {"Genital", "Head"},
--         TattooIndex = {"Genital", "Head"},
--         LipsMakeupIntensity = {"Genital", "Head"},
--         CustomIndex = {"Genital", "Head"},
--         CustomIntensity = {"Genital", "Head"},
--         MakeUpIndex = {"Genital", "Head"},
--         LipsMakeupRoughness = {"Genital", "Head"},
--         MakeupRoughness = {"Genital", "Head"},
--     },
--     Vector = {
--         _WrinkleWeightsR = {"Genital", "Head"},
--         _WrinkleWeightsG = {"Genital", "Head"},
--         _WrinkleWeightsB = {"Genital", "Head"},
--         _WrinkleWeightsA = {"Genital", "Head"},
--         TattooIntensity = {"Genital", "Head"},
--         BodyTattooIntensity = {"Body", "Genital"},
--         CustomColor = {"Genital", "Head"},
--     },
--     Vector3 = {
--         GlowColor = {"Body", "Genital", "Head"},
--         HemoglobinColor = {"Body", "Genital", "Head"},
--         VeinColor = {"Body", "Genital", "Head"},
--         MelaninColor = {"Body", "Genital", "Head"},
--         YellowingColor = {"Body", "Genital", "Head"},
--         BodyTattooColor = {"Body", "Genital"},
--         BodyTattooColorG = {"Body", "Genital"},
--         BodyTattooColorB = {"Body", "Genital"},
--         BodyTattooColorA = {"Body", "Genital"},
--         AdditionalTattooColorB = {"Body", "Genital", "Head"},
--         NonSkinColor = {"Body", "Genital", "Head"},
--         DirtColor = {"Body", "Genital", "Hair", "Head"},
--         Blood_Color = {"Body", "Genital", "Hair", "Head"},
--         Lips_Makeup_Color = {"Genital", "Head"},
--         MakeupColor = {"Genital", "Head"},
--         TattooColor = {"Genital", "Head"},
--         TattooColorG = {"Genital", "Head"},
--         TattooColorB = {"Genital", "Head"},
--         TattooColorA = {"Genital", "Head"},
--         Body_Hair_Color = {"Body", "Genital"},
--         IllithidVeinColor = {"Body", "Head"},
--     }
-- }

defaultTattooes = {
    'No Tattoo',
    'Migration',
    'Squidilection',
    'Strongarm Syndicate',
    'Hollow Spaces',
    'Buggish Curls',
    'Shriek Mask',
    'Starpoint Glimmer',
    'Nightjar Blots',
    'Spiderlip',
    'Fiendhorn Lids',
    'Flaring Sword',
    'Switchback Trail',
    'Woven Razors',
    'Caldera',
    'Sinner Cheekbone',
    'Plashing Tailfin',
    'Fallen Leaves',
    'Pouring Hate',
    'Fungal Cloud',
   'Cursed Rose',
    'Scrawled Constellation',
    'Yggdrasil',
    'Totemic Throat',
    'Dolmen Cross',
    'Suffusion',
    'Faewild Syndicate',
    'From The Deep',
    'Beholder Gorgon',
    'Chastened',
    'Blake Tiger',
    'Sharp Candelabra',
    'Polkadots',
    'Wicked Reaper',
    'Brokenshard Sword',
    'Guerilla',
    'War Boars',
    'Masque of Wrath',
    'Ivy Trellis',
    'Searching Chains',
    'Mechanus Moons',
    'Centipedes',
    'Mud Worms',
    'Macabre Chinstrap',
    'Dread Fog',
}


BodyVirtualTextures = {
    'ae852291-e770-8a10-a38c-057f9c22bb5c',
    '85478d1d-df4a-b0e8-8d8b-57ba057dd5ea',
    '75ada7a3-af56-93ed-f168-0a8edcb049da',
    'b1e6f850-1d87-9443-e0c4-17d135a41521',
    '98eb4b27-ac9d-51c1-9463-1110a0851483',
    'e807633b-7180-65e3-74f8-f653c2bf0d17',
    'eefa0aa0-34ea-be5d-8050-6b33b75096bf',
    'c17522af-218c-f2fd-bb0f-807e5f3f4f07',
    '853ccc12-ff5b-5411-5595-819e0e6f95ea',
    '1f0f2a16-e968-e5f5-8cce-f636095d188c',
    '62ac0ec8-5979-c10c-5766-198384c43237',
    '933ecb7a-a6e7-c4dc-774c-edaccc5d8147',
    '5d7285df-d505-4b4d-8596-8ca9dc4272f4',
    '6b828c9f-bd36-b110-5780-58ad385e5920',
    '4149f8e1-b78f-9eeb-5741-54fa67ad9868',
    '0135c710-700b-4baa-887b-199603c0ba68',
    '11559ac3-4157-26a6-2d2b-eb64d09d8a3c',
    '47f18258-c960-4ec8-c966-a955ef6f167e',
    '7adb31c4-7536-9993-785d-a0ad11b5ee32',
    'c8079b66-d0fd-80c5-8f7d-c3951578676a',
    '7c38ae74-3de5-b757-d832-cb744e221da8',
    '429232e5-6fe7-196f-a5c4-eeee28e4190c',
    'fcfb0e8a-e167-01b5-b0c3-c8300cffdf23',
    '7bc1e54e-0aa1-0c59-0800-d8ae96e68276',
    '22c0c93c-ef13-a6db-d29c-b48202694147',
    'f512821e-afb3-dbf4-c9d4-130473b33176',
    'e6d80282-13df-f3bc-66a7-c6e0577fb249',
    '885d5e96-3e15-2fef-f1e9-2a1e184628a9',
    '06e705f4-a7ed-eea2-3187-094982a6af52',
    'a68e3b7f-fd4e-bff8-ac44-543f947400b8',
    '2c4659e9-3b06-7cb7-ff7f-e18b7d2a99a9',
    '9392ce52-a12d-c8ce-b19e-1a1125e6365c',
    '949c995c-bde7-8a73-c8ad-6bb540fae45e',
    '9f31d66d-1115-f32e-e1a0-c8bb263101cd',
    '958f4f74-03e6-ff59-3d7c-b6e73669b72d',
    'bbbbacd7-0b3c-7853-e4bf-9d9564ff171d',
    'fd84e95f-2131-5a42-0fee-fe2af61eff20',
    '6236e469-34e2-f453-6bfd-ec6c0d9c6b3f',
    '83235a90-1957-5822-7095-2011be1944e4',
    'debfcf5a-e73d-7e43-ba8f-e525e140e9a2',
    'e447a9a9-f0e3-e8ef-24b6-a95676ef6e27',
    '34d3a79f-b540-07b5-d2ba-22e30833e8bd',
    'b74eb715-3ee2-c3f5-f59c-c96aa76cde64',
    '8442ecb3-be19-2ef3-0ce1-b95b420727f5',
    'fde1ea4f-5d72-f1ce-826e-bdefe1521b0e',
    '44dc58ea-fc84-c3ad-43e7-1f26ec9745ec',
    '79569033-984f-c8d0-01e0-1d60a417e38e',
    '89a96329-e0ae-dafe-b0ce-176cb08453d2',
    'ff5cf6db-a848-9c24-c728-6c2ddb96faa4',
    '048b475d-73d6-2a82-b30e-1208b5b06ddf',
    '58e09cb4-8de7-d521-3d51-1ae5a57165e3',
    'bd2639d6-dba2-7f57-6b60-b894def581d4',
    '1f7f35b0-b32f-e611-6a97-8ff847ccb9ab',
    'e302f3a7-d0c1-a93b-4e86-dac610efd848',
    '9c945d25-9649-bf74-ab9b-2dcc6d107287',
    'edd7fe22-7608-fac4-134b-8af9d0635b54',
    'd2061451-20f6-5867-efd5-86f142f010f9',
    '919a5892-78df-1f1a-ed1d-1aff6a9fd1b7',
    '42ba109c-0c7f-6d68-33bb-e39d15a95be7',
    'bb2b88ad-85ef-14ac-3493-16723a7c804b',
    '86fae242-bd60-2661-971c-a2886d9d82a0',
    'ba3ce656-6f58-7a33-4365-a1809a08d99b',
    '6ffc0f34-a5f7-58ef-246f-af64487a63ad',
    'c389db1b-a81f-4362-da95-86952c25fa80',
    'd6052ae7-cd34-544f-bd25-1f6ca07a05da',
    '943b124f-b6e9-92e3-f105-7b5e6da008c7',
    '2dcb63ac-a493-c7f2-5765-167b230e8cad',
    '83a8d926-9cb0-6b9e-cc9b-6e154d873b70',
    '589bbde8-9039-b092-bf62-0840d5ccba1a',
    'f2756a69-143f-321e-6734-0b36a02deb0f',
    'd6b0382f-159f-2118-9ea6-fef29cf757b7',
    '67c3c432-6255-4d74-cf57-427c994e940a',
    'f3e7e23a-913b-4348-98a2-c752fdfbb76f',
    'c46039cf-3db4-4764-9a5c-fb27419db6af',
    'ada00683-808b-4a37-99a6-2443a5660be6',
    'bc8521ea-71a2-416c-aa28-387f827bb7c3',
}

-- defaultMaterials = {

--     '3fa84d0c-016b-65bd-3b16-fc7892eaa85d', --DEF_HUM_M
--     'ceff760d-6904-40bd-9a8d-8cf84993020f', --DEF_HUM_MS
--     '5e46e917-0c94-44ae-a41e-96428aa5ea32', --DEF_HUM_F
--     '9106a412-4963-2147-914b-838fd337cf43', --DEF_HUM_FS

--     '80567441-dafe-b6c6-4873-aa67bff518bc', --DEF_ELF_F
--     'a4aca4bd-08f7-000d-a124-34a900af1401', --DEF_ELF_FS
--     'daa3e1df-e6df-c6b6-3bf7-4d0b601cdc11', --DEF_ELF_M
--     '1be46b94-3198-09d4-d2cc-be6a3bbe8250', --DEF_ELF_MS

--     '8ab7eeb5-49ad-e5ba-9d60-69cec6a3d751', --DEF_TIF_M
--     '8ab7eeb5-49ad-e5ba-9d60-69cec6a3d751', --DEF_TIF_MS
--     'b3b205a0-3570-c06c-65a9-df9b95afc435', --DEF_TIF_F
--     '6d46fd76-b821-9d89-78e5-52674d7a0416', --DEF_TIF_FS

--     'f31368ee-9365-194a-cc1f-2fa7baa51636', --DEF_GTY_M
--     '1c7022af-5d72-61b2-e49e-766148eb14c6', --DEF_GTY_F


--     '1ee43dd1-d052-9be8-066b-9714f5519247', --DEF_GNO_M
--     '9f5f2247-0346-354d-3e0b-4bcf964eddad', --DEF_GNO_F

--     'd568f461-2c10-b6df-6c18-489d45c20a61', --DEF_DWR_M
--     'e8d26284-a96e-48ce-b7af-9a46ab219245', --DEF_DWR_F

--     '7a5afaa4-7427-853d-c6b7-90454f383d0e', --DEF_DGB_M
--     '9b45c363-a889-3b9f-9822-b3cd50c9b74a', --DEF_DGB_F

--     '4de0352a-4c53-79d2-525f-0d5f058bd2eb', --DEF_HFL_M
--     'dd207edd-ed7e-83e1-8bc1-6c0f852f6f6d', --DEF_HFL_F

--     'bb4db85d-8b08-8f63-7c47-2545ce62ff41', --DEF_HRC_M
--     '1d6a1ec7-c34e-cb82-1bd2-65e1b0f3830c', --DEF_

--     '', --DEF_


--     '1594b4da-6db1-471b-9a1a-c1ad4ecf721b', --UTAV


-- }






-- Ext.Resource.Get('1594b4da-6db1-471b-9a1a-c1ad4ecf721b', 'Material').VirtualTextureParameters[1].Enabled = false
-- _D(_C().Visual.Visual.Attachments[1].Visual.ObjectDescs[1].Renderable.ActiveMaterial:SetVirtualTexture('virtualtexture', 'eefa0aa0-34ea-be5d-8050-6b33b75096bf'))