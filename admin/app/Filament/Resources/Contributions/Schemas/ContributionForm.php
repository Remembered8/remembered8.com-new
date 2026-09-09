<?php

namespace App\Filament\Resources\Contributions\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class ContributionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('memorial_id')
                    ->relationship('memorial', 'id')
                    ->required(),
                TextInput::make('kind')
                    ->required(),
                TextInput::make('author_name')
                    ->required()
                    ->default(''),
                TextInput::make('relation')
                    ->required()
                    ->default(''),
                TextInput::make('location')
                    ->required()
                    ->default(''),
                Textarea::make('body')
                    ->required()
                    ->default('')
                    ->columnSpanFull(),
                Textarea::make('payload')
                    ->columnSpanFull(),
                Toggle::make('is_approved')
                    ->required(),
            ]);
    }
}
