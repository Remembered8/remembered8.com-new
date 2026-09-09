<?php

namespace App\Filament\Resources\Memorials\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Schema;

class MemorialForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema->components([
            Section::make('Dossier')
                ->description('The queryable summary. The full profile document is edited by the family in the app.')
                ->columns(2)
                ->columnSpanFull()
                ->schema([
                    TextInput::make('full_name')
                        ->label('Full name')
                        ->required()
                        ->maxLength(255),

                    TextInput::make('slug')
                        ->required()
                        ->maxLength(200)
                        ->unique(ignoreRecord: true)
                        ->helperText('Used in the URL a QR plaque resolves to. Changing it breaks engraved plaques.'),

                    TextInput::make('profession')
                        ->label('Vocation and legacy')
                        ->maxLength(255),

                    TextInput::make('birth_place')
                        ->label('Birthplace')
                        ->maxLength(255),

                    Select::make('category')
                        ->options([
                            'civilian' => 'Family record',
                            'historical' => 'Historical figure',
                            'animal_companion' => 'Animal companion',
                        ])
                        ->required(),

                    Select::make('privacy')
                        ->options([
                            'public' => 'Public living archive',
                            'private_link' => 'Unlisted direct link',
                            'family_only' => 'Family and authorised kin only',
                        ])
                        ->required()
                        ->helperText('Only public dossiers appear in the registry listing.'),
                ]),

            Section::make('Curation')
                ->columns(2)
                ->columnSpanFull()
                ->schema([
                    Toggle::make('is_verified_historic')
                        ->label('Verified historical figure'),

                    Toggle::make('is_seed')
                        ->label('Curated record')
                        ->helperText('Curated records refuse rewrites through the public API, so visitors cannot edit them.'),

                    TextInput::make('candle_count')
                        ->label('Candles lit')
                        ->numeric()
                        ->minValue(0)
                        ->required()
                        // Editing the tally by hand would contradict the
                        // contributions that produced it.
                        ->disabled(fn (Get $get): bool => (bool) $get('is_seed') === false)
                        ->dehydrated(),
                ]),
        ]);
    }
}
